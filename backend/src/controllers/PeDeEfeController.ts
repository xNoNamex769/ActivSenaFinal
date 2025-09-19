import { Request, Response } from "express";
import { Asistencia } from "../models/Asistencia";
import { Usuario } from "../models/Usuario";
import { Actividad } from "../models/Actividad";
import { Evento } from "../models/Evento";
import PDFDocument from "pdfkit";

export class PdfController {
  static generarPdfAsistencias = async (req: Request, res: Response) => {
    try {
      const { IdActividad } = req.params;

      // Buscar la actividad y evento
      const actividad = await Actividad.findByPk(IdActividad, {
        include: [Evento],
      });

      if (!actividad) {
        return res.status(404).json({ error: "Actividad no encontrada" });
      }

      // Obtener todas las asistencias relacionadas con esta actividad
      const asistencias = await Asistencia.findAll({
        where: { IdActividad: IdActividad },
        include: [
          {
            model: Usuario,
          },
        ],
        order: [["AsiFecha", "ASC"]],
      });

      // Crear documento PDF
      const doc = new PDFDocument({ margin: 30, size: "A4" });

      res.setHeader("Content-Disposition", `attachment; filename=asistencias_${IdActividad}.pdf`);
      res.setHeader("Content-Type", "application/pdf");

      doc.pipe(res);

      doc.fontSize(20).text(`Asistencias - ${actividad.NombreActi}`, { align: "center" });
      doc.moveDown();
      doc.fontSize(14).text(`Evento: ${actividad.evento?.NombreEvento || "Sin evento"}`);
      doc.text(`Fecha: ${actividad.FechaInicio} - ${actividad.FechaFin}`);
      doc.moveDown();

      doc.fontSize(12);
      doc.text("N°", { continued: true, width: 30 });
      doc.text("Nombre", { continued: true, width: 150 });
      doc.text("Correo", { continued: true, width: 150 });
      doc.text("Identificación", { continued: true, width: 100 });
      doc.text("Entrada", { continued: true, width: 80 });
      doc.text("Salida", { continued: true, width: 80 });
      doc.text("Horas", { continued: true, width: 50 });
      doc.text("Estado", { width: 80 });
      doc.moveDown();

      asistencias.forEach((asi, index) => {
        doc.text((index + 1).toString(), { continued: true, width: 30 });
        doc.text(`${asi.usuario?.Nombre || ""} ${asi.usuario?.Apellido || ""}`, { continued: true, width: 150 });
        doc.text(asi.usuario?.Correo || "", { continued: true, width: 150 });
        doc.text(asi.usuario?.IdentificacionUsuario || "", { continued: true, width: 100 });
        doc.text(asi.QREntrada ? asi.QREntrada.toISOString().slice(0, 19).replace("T", " ") : "-", { continued: true, width: 80 });
        doc.text(asi.QRSalida ? asi.QRSalida.toISOString().slice(0, 19).replace("T", " ") : "-", { continued: true, width: 80 });
        doc.text(asi.AsiHorasAsistidas?.toString() || "0", { continued: true, width: 50 });
        doc.text(asi.AsiEstado || "Incompleta", { width: 80 });
      });

      doc.end();

    } catch (error) {
      console.error("Error generando PDF de asistencias:", error);
      res.status(500).json({ error: "Error interno al generar PDF" });
    }
  };
}
