import type { Request, Response } from "express";
import { Usuario } from "../models/Usuario";
import { checkcontrasena, hashPassword } from "../utils/auth";
import { generateToken } from "../utils/token";
import { generateJWT } from "../utils/jwt";
import { AuthEmail } from "../emails/AuthEmail";
import { RolUsuario } from "../models/RolUsuario";
import { Aprendiz } from "../models/Aprendiz";

// Controlador encargado de gestionar operaciones relacionadas con el modelo Usuario
export class UsuarioController {
  // Obtener todos los usuarios ordenados por fecha de creación
  static getAll = async (req: Request, res: Response) => {
    try {
      console.log("GET /api/usuario - Obtener todos los usuarios");
      const usuarios = await Usuario.findAll({
        order: [["createdAt", "ASC"]],
      });
      res.json(usuarios);
    } catch (error) {
      res.status(500).json({ error: "Hubo un error al obtener los usuarios" });
    }
  };

  // Obtener un usuario por su ID
  static getUsuarioId = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) {
        res.status(404).json({ error: "Usuario no encontrado." });
        return;
      }

      res.json(usuario);
    } catch (error) {
      res.status(500).json({ error: "Hubo un error al buscar el usuario." });
    }
  };

  // Crear un nuevo usuario
  static crearUsuario = async (req: Request, res: Response) => {
  try {
    const {
      IdentificacionUsuario,
      Nombre,
      Apellido,
      Correo,
      Telefono,
      Contrasena,
      FechaRegistro,
      Ficha,
      ProgramaFormacion,
      Jornada,
    } = req.body;

    // Validación de campos obligatorios
    if (
      !IdentificacionUsuario ||
      !Nombre ||
      !Apellido ||
      !Correo ||
      !Telefono ||
      !Contrasena ||
      !FechaRegistro
    ) {
      res.status(400).json({ error: "Todos los campos son obligatorios" });
      return;
    }

    // Encriptar contraseña y generar token de verificación
    const hashedPassword = await hashPassword(Contrasena);
    const token = generateToken();

    // Crear usuario base
    const usuario = await Usuario.create({
      IdentificacionUsuario,
      Nombre,
      Apellido,
      Correo,
      Telefono,
      Contrasena: hashedPassword,
      FechaRegistro,
      token,
      IdRol: 2, // Asignamos rol de aprendiz
      confirmed: false,
    });

    // 👉 Crear RolUsuario
    const rolUsuario = await RolUsuario.create({
      IdUsuario: usuario.IdUsuario,
      NombreRol: "Aprendiz",
    });

    // 👉 Crear Aprendiz (solo si llegan datos)
    if (Ficha && ProgramaFormacion && Jornada) {
      await Aprendiz.create({
        IdUsuario: usuario.IdUsuario,
        IdRolUsuario: rolUsuario.IdRol,
        Ficha,
        ProgramaFormacion,
        Jornada,
      });
    }

    // Enviar correo
    await AuthEmail.sendConfirmationEmail({
      Nombre: usuario.Nombre,
      Correo: usuario.Correo,
      token: usuario.token ?? "",
    });

    res.status(201).json({ mensaje: "Usuario y aprendiz creados correctamente." });
  } catch (error) {
    console.error("Error en crearUsuario:", error);
    res.status(500).json({ error: "Error al crear usuario." });
  }
};

  // Actualizar usuario por ID
  static actualizarUsuarioId = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) {
        res.status(404).json({ error: "Usuario no encontrado." });
        return;
      }

      await usuario.update(req.body);
      res.json("Usuario actualizado exitosamente.");
    } catch (error) {
      res.status(500).json({ error: "Error al actualizar usuario." });
    }
  };

  // Eliminar usuario por ID
  static borrarUsuarioId = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) {
        res.status(404).json({ error: "Usuario no encontrado." });
        return;
      }

      await usuario.destroy();
      res.json("Usuario eliminado exitosamente.");
    } catch (error) {
      res.status(500).json({ error: "Error al eliminar usuario." });
    }
  };

  // Confirmar cuenta con token
  static confirmAccount = async (req: Request, res: Response) => {
    const { token } = req.body;
    const usuario = await Usuario.findOne({ where: { token } });

    if (!usuario) {
      res.status(401).json({ error: "Token no válido" });
      return;
    }

    usuario.confirmed = true;
    usuario.token = "";
    await usuario.save();

    res.json("Cuenta confirmada correctamente");
  };

  // Iniciar sesión
  static login = async (req: Request, res: Response) => {
    const { Correo, Contrasena } = req.body;

    const usuario = await Usuario.findOne({ where: { Correo } });

    if (!usuario) {
      res.status(409).json({ error: "Usuario no encontrado" });
      return;
    }

    if (!usuario.confirmed) {
      res.status(403).json({ error: "La cuenta no ha sido confirmada" });
      return;
    }

    const isContrasenaCorrecta = await checkcontrasena(
      Contrasena,
      usuario.Contrasena
    );

    if (!isContrasenaCorrecta) {
      res.status(401).json({ error: "Contraseña incorrecta" });
      return;
    }

    const token = generateJWT(usuario.IdUsuario, usuario.IdRol);

res.status(200).json({
  token,
  usuario: {
    IdUsuario: usuario.IdUsuario,
    Nombre: usuario.Nombre,
    Correo: usuario.Correo,
    IdRol: usuario.IdRol
 
  }
});


  };

  // Solicitar cambio de contraseña
  static forgotContrasena = async (req: Request, res: Response) => {
    const { Correo } = req.body;
    const usuario = await Usuario.findOne({ where: { Correo } });

    if (!usuario) {
      res.status(409).json({ error: "Usuario no encontrado" });
      return;
    }

    usuario.token = generateToken();
    await usuario.save();

    await AuthEmail.sendContrasenaResetToken({
      Nombre: usuario.Nombre,
      Correo: usuario.Correo,
      token: usuario.token,
    });

    res.json("Revisa tu correo para instrucciones");
  };

  // Validar token de recuperación de contraseña
  static validateToken = async (req: Request, res: Response) => {
    const { token } = req.body;
    const tokenExists = await Usuario.findOne({ where: { token } });

    if (!tokenExists) {
      res.status(404).json({ error: "Token no válido" });
      return;
    }

    res.json("Token válido...");
  };

  // Resetear contraseña usando token
  static resetpasswordWithToken = async (req: Request, res: Response) => {
    const { token } = req.params;
    const { Contrasena } = req.body;

    const usuario = await Usuario.findOne({ where: { token } });

    if (!usuario) {
      res.status(404).json({ error: "Token no válido" });
      return;
    }

    usuario.Contrasena = await hashPassword(Contrasena);
    usuario.token = null;
    await usuario.save();

    res.json("La contraseña se modificó correctamente");
  };

  // Obtener usuario autenticado desde el token JWT
  static usertraer = async (req: Request, res: Response) => {
    if (!req.usuario) {
      res.status(404).json({ error: "Usuario no encontrado" });
      return;
    }

    res.json(req.usuario);
  };
  static updateCurrentPassword = async (req: Request, res: Response) => {
  const { Actualizar_Contrasena, Contrasena } = req.body;

  if (!req.usuario) {
    res.status(401).json({ error: "No autorizado" });
    return;
  }

  const id = req.usuario.IdUsuario;

  try {
    const usuario = await Usuario.findByPk(id);

    if (!usuario) {
      res.status(404).json({ error: "Usuario no encontrado" });
      return
    }

    const isContrasenaCorrecta = await checkcontrasena(
      Actualizar_Contrasena,
      usuario.Contrasena
    );

    if (!isContrasenaCorrecta) {
      res.status(401).json({ error: "La contraseña actual es incorrecta" });
      return;
    }

 
    const nuevaHash = await hashPassword(Contrasena); 
    usuario.Contrasena = nuevaHash;
    await usuario.save();

    res.json({ mensaje: "Contraseña actualizada correctamente" });
  } catch (error) {
    console.error("Error al actualizar la contraseña:", error);
    res.status(500).json({ error: "Error del servidor" });
  }
};


// src/controllers/UsuarioController.ts
static actualizarTelefono = async (req: Request, res: Response) => {
  const { id } = req.params;
  const { Telefono } = req.body;

  try {
    const usuario = await Usuario.findByPk(id);
    if (!usuario) {
       res.status(404).json({ error: 'Usuario no encontrado' });
       return;
    }

    usuario.Telefono = Telefono;
    await usuario.save();

    res.json(usuario);
  } catch (error) {
    console.error("Error al actualizar teléfono:", error);
    res.status(500).json({ error: 'Error al actualizar número' });
  }
};


// src/controllers/UsuarioController.ts

static cambiarRolUsuario = async (req: Request, res: Response) => {
  const { id } = req.params;
  const { IdRol } = req.body;

  try {
    const usuario = await Usuario.findByPk(id);

    if (!usuario) {
       res.status(404).json({ error: "Usuario no encontrado" });
       return;
    }

    usuario.IdRol = IdRol;
    await usuario.save();

    res.json({ mensaje: "Rol actualizado correctamente", usuario });
  } catch (error) {
    console.error("Error al cambiar rol:", error);
    res.status(500).json({ error: "Error al cambiar el rol" });
  }
};
}