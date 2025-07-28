import React, { useState, useEffect } from "react";
import "./style/RegistroActividades.css";
import cuadradoImg from './img/cuadrado.jpg';
import axios from "axios";
import sindesenaLogo from "../../../public/img/sindesena.webp"; // Importar logo
const formatearFecha = (fechaStr) => {
  if (!fechaStr) return "";
  const [year, month, day] = fechaStr.split("-");
  const meses = [
    "enero", "febrero", "marzo", "abril", "mayo", "junio",
    "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
  ];
  return `${parseInt(day)} de ${meses[parseInt(month) - 1]} de ${year}`;
};

const ActivityRegistration = () => {
  const [activityData, setActivityData] = useState({
    activityName: "",
    description: "",
    date: "",
    startTime: "",
    endTime: "",
    location: "",
    capacity: "",
    organizer: "",
    infoLink: "",
    image: cuadradoImg,
    IdEvento: "",
    tipoLudica: "",
  });

  const [imageFile, setImageFile] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [eventos, setEventos] = useState([]);

  useEffect(() => {
    axios.get("http://localhost:3001/api/evento")
      .then(res => setEventos(res.data))
      .catch(err => console.error("Error cargando eventos", err));
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setActivityData({ ...activityData, [name]: value });
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const imageURL = URL.createObjectURL(file);
      setActivityData({ ...activityData, image: imageURL });
      setImageFile(file);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (activityData.startTime >= activityData.endTime) {
      alert("⚠️ La hora de inicio debe ser anterior a la hora de fin.");
      return;
    }

    const hoy = new Date();
const hoySinHora = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
const [year, month, day] = activityData.date.split("-");
const fechaSeleccionada = new Date(parseInt(year), parseInt(month) - 1, parseInt(day));

if (fechaSeleccionada < hoySinHora) {
  alert("⚠️ No puedes registrar una actividad en una fecha pasada.");
  return;
}


    setShowModal(true);
  };

  const handleConfirm = async () => {
    setShowModal(false);

    const token = localStorage.getItem("token");
    if (!token) {
      alert("⚠️ Debes iniciar sesión.");
      return;
    }

    try {
      const decoded = JSON.parse(atob(token.split('.')[1]));
      const idUsuario = decoded?.IdUsuario;
      const rolUsuario = decoded?.rol;

      if (rolUsuario !== 3) {
        alert("⚠️ Solo los instructores pueden registrar actividades.");
        return;
      }

      if (!idUsuario) {
        alert("⚠️ No se pudo identificar al usuario.");
        return;
      }

      if (!imageFile) {
        alert("Debes seleccionar una imagen para la actividad.");
        return;
      }

      const startTime = activityData.startTime.length === 5
        ? `${activityData.startTime}:00`
        : activityData.startTime;

      const endTime = activityData.endTime.length === 5
        ? `${activityData.endTime}:00`
        : activityData.endTime;

      const formData = new FormData();
      formData.append("NombreActi", activityData.activityName);
      formData.append("Descripcion", activityData.description);
      formData.append("FechaInicio", activityData.date);
      formData.append("FechaFin", activityData.date);
      formData.append("HoraInicio", startTime);
      formData.append("HoraFin", endTime);
    
      formData.append("Ubicacion", activityData.location);
      formData.append("Imagen", imageFile);
      formData.append("IdUsuario", idUsuario);
      formData.append("TipoLudica", activityData.tipoLudica);

      if (activityData.IdEvento) {
        formData.append("IdEvento", activityData.IdEvento);
      }

      await axios.post("http://localhost:3001/api/actividad", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      alert("✅ Actividad registrada con éxito");

    } catch (error) {
      console.error("❌ Error al registrar actividad:", error);
      alert("Hubo un error al registrar la actividad.");
    }
  };

  const handleCancel = () => {
    setShowModal(false);
  };

  return (
    <div className="activity-wrapper">
      <div className="image-container">
        <img src={activityData.image} alt="Vista previa" className="preview-image" />
        <input type="file" name="image" accept="Image/*" onChange={handleImageChange} />
      </div>

      <div className="activity-container">
        <h2>📅 Registro de Actividad</h2>
        <form onSubmit={handleSubmit}>
          <label>
            🏆 Nombre de la actividad
            <input type="text" name="activityName" value={activityData.activityName} onChange={handleChange} required />
          </label>

          <label>
            📝 Descripción
            <textarea name="description" value={activityData.description} onChange={handleChange} rows="3" required />
          </label>

          <label>
            📅 Fecha
            <input type="date" name="date" value={activityData.date} onChange={handleChange} required />
          </label>

          <div className="time-container">
            <label>
              ⏰ Hora de inicio
              <input type="time" name="startTime" value={activityData.startTime} onChange={handleChange} required />
            </label>
            <label>
              ⏳ Hora de fin
              <input type="time" name="endTime" value={activityData.endTime} onChange={handleChange} required />
            </label>
          </div>

          <label>
            📍 Ubicación
            <input type="text" name="location" value={activityData.location} onChange={handleChange} required />
          </label>

          <label>
            📌 Evento
            <select name="IdEvento" value={activityData.IdEvento} onChange={handleChange}>
              <option value="">-- Sin evento asociado --</option>
              {eventos.map((evento) => (
                <option key={evento.IdEvento} value={evento.IdEvento}>
                  {evento.NombreEvento}
                </option>
              ))}
            </select>
          </label>
          <label>
  🗂 Tipo
 <select name="tipoLudica" value={activityData.tipoLudica} onChange={handleChange} required>
  <option value="">-- Selecciona una opción --</option>
  <option value="Noticia">📢 SINDESENA</option>
  <option value="Cultural">🎭 Cultural</option>
  <option value="Deportiva">🏅 Deportiva</option>
  <option value="Recreativa">🎲 Recreativa</option>
</select>

{activityData.tipoLudica === "Noticia" && (

  <div style={{ marginTop: "10px" }}>
    <img
      src={sindesenaLogo}
      alt="Logo SINDESENA"
      style={{ width: "120px", height: "auto" }}
    />
    <p style={{ fontWeight: "bold", color: "#333" }}>SINDESENA</p>
  </div>
)}

</label>


          <button type="submit">✅ Registrar Actividad</button>
        </form>
      </div>

      {showModal && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h3>Confirma la información de la actividad</h3>
            <p><strong>Nombre:</strong> {activityData.activityName}</p>
            <p><strong>Descripción:</strong> {activityData.description}</p>
            <p><strong>Fecha:</strong> {formatearFecha(activityData.date)}</p>
            <p><strong>Hora inicio:</strong> {activityData.startTime}</p>
            <p><strong>Hora fin:</strong> {activityData.endTime}</p>
            <p><strong>Ubicación:</strong> {activityData.location}</p>
            <p><strong>Tipo:</strong> {activityData.tipoLudica}</p>

            <p>
              <strong>Evento:</strong>{" "}
              {eventos.find(e => e.IdEvento === parseInt(activityData.IdEvento))?.NombreEvento || "Sin evento"}
            </p>
            <div className="modal-buttons">
              <button onClick={handleConfirm}>Aceptar</button>
              <button onClick={handleCancel}>Cancelar</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ActivityRegistration;
