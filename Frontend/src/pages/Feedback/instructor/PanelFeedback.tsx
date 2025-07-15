import React, { useEffect, useState } from "react";
import axios from "axios";
import "../styles/PanelFeedback.css"; // Asegúrate de tener este archivo CSS
const PanelFeedbacks = () => {
  const [feedbacks, setFeedbacks] = useState([]);

  useEffect(() => {
    axios
      .get("http://localhost:3001/api/feedback")
      .then((res) => setFeedbacks(res.data))
      .catch((err) => console.error("Error al cargar feedbacks:", err));
  }, []);

  return (
    <div className="panel-feedbacks-container">
      <h2 className="text-2x">📋 Panel de Feedbacks</h2>

      <div className="overflow-x-auto">
        <table className="table-feedbacks">
          <thead>
            <tr className="bg-gray-100 text-left text-sm uppercase">
              <th className="p-3">Usuario</th>
              <th className="p-3">Comentario</th>
              <th className="p-3">Calificación</th>
              <th className="p-3">Fecha</th>
              <th className="p-3">Tipo</th>
              <th className="p-3">Nombre Actividad / Tipo Ayuda</th>
            </tr>
          </thead>
          <tbody>
            {feedbacks.map((f: any) => (
              <tr key={f.IdFeedback} className="border-t hover:bg-gray-50">
                <td className="p-3">{f.usuario?.Nombre} {f.usuario?.Apellido}</td>
                <td className="p-3">{f.ComentarioFeedback}</td>
                <td className="p-3">{f.Calificacion} ⭐</td>
                <td className="p-3">{new Date(f.FechaEnvio).toLocaleDateString()}</td>
                <td className="p-3">{f.IdActividad ? "Actividad" : "Solicitud"}</td>
                <td className="p-3">
                  {f.actividad?.NombreActi || f.solicitud?.TipoAyuda || "-"}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default PanelFeedbacks;
