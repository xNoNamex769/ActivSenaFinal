import React, { useEffect, useState } from "react";
import axios from "axios";
import "./style/GestionFormulario.css"; 
const GestionCatalogo = () => {
  const [elementos, setElementos] = useState([]);
  const [imagenNueva, setImagenNueva] = useState({});
  const [mensaje, setMensaje] = useState("");

  const cargarElementos = async () => {
    const res = await axios.get("http://localhost:3001/api/alquilerelementos/catalogo");
    setElementos(res.data);
  };

  useEffect(() => {
    cargarElementos();
  }, []);

  const handleImagenChange = (e, id) => {
    setImagenNueva({ ...imagenNueva, [id]: e.target.files[0] });
  };

  const actualizarImagen = async (id) => {
    if (!imagenNueva[id]) return;

    const formData = new FormData();
    formData.append("imagen", imagenNueva[id]);

    try {
      await axios.put(`http://localhost:3001/api/alquilerelementos/catalogo/${id}/imagen`, formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      setMensaje("Imagen actualizada correctamente");
      cargarElementos();
    } catch (error) {
      console.error("Error al actualizar imagen:", error);
      setMensaje("Error al actualizar imagen");
    }
  };

  const eliminarElemento = async (id) => {
    if (!window.confirm("¿Estás seguro de eliminar este elemento?")) return;

    try {
      await axios.delete(`http://localhost:3001/api/alquilerelementos/catalogo/${id}`);
      setMensaje("Elemento eliminado correctamente");
      cargarElementos();
    } catch (error) {
      console.error("Error al eliminar:", error);
      setMensaje("Error al eliminar elemento");
    }
  };

  return (
    <div className="gestion-catalogo">
      <h2>Gestión de Elementos del Catálogo</h2>
      {mensaje && <p>{mensaje}</p>}

      <div className="lista-elementos">
        {elementos.map((el) => (
          <div key={el.IdAlquiler} className="item-catalogo">
            <img
              src={`http://localhost:3001/uploads/${el.Imagen}`}
              alt={el.NombreElemento}
              width="120"
            />
            <p><strong>{el.NombreElemento}</strong></p>
            <input type="file" onChange={(e) => handleImagenChange(e, el.IdAlquiler)} />
            <button onClick={() => actualizarImagen(el.IdAlquiler)}>Actualizar imagen</button>
            <button onClick={() => eliminarElemento(el.IdAlquiler)} style={{ color: "red" }}>
              Eliminar elemento
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default GestionCatalogo;
