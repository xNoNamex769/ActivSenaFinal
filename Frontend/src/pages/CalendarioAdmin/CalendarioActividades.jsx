
import React, { useState, useEffect } from 'react';
import './style/Calendario.css';
import fondo4 from './img/fondo4.jpg';
import { FaBell } from 'react-icons/fa';
import axios from 'axios';

const CalendarioAp = () => {
  // Estados principales del componente
  const [events, setEvents] = useState([]); // Eventos cargados desde backend
  const [calendarEvents, setCalendarEvents] = useState([]); // Eventos filtrados para el calendario actual
  const [showNotifications, setShowNotifications] = useState(false); // Panel de notificaciones
  const [showInfoModal, setShowInfoModal] = useState(false); // Modal de detalles
  const [selectedEvent, setSelectedEvent] = useState(null); // Evento seleccionado para ver detalles
  const [currentDate, setCurrentDate] = useState(new Date()); // Fecha actual para el calendario
  const [clickedNotifications, setClickedNotifications] = useState([]); // Eventos que ya fueron clickeados
const [showFeedback, setShowFeedback] = useState(false);
const [feedbackText, setFeedbackText] = useState("");
const [feedbackRating, setFeedbackRating] = useState(5);



  // Funciones para cambiar de mes
  const irAlMesAnterior = () => {
    const nuevaFecha = new Date(currentDate);
    nuevaFecha.setMonth(nuevaFecha.getMonth() - 1);
    setCurrentDate(nuevaFecha);
  };

  const irAlMesSiguiente = () => {
    const nuevaFecha = new Date(currentDate);
    nuevaFecha.setMonth(nuevaFecha.getMonth() + 1);
    setCurrentDate(nuevaFecha);
  };

  // Efecto que carga eventos desde el backend y los filtra por mes
  useEffect(() => {
    const fetchEventos = async () => {
      try {
        const res = await axios.get("http://localhost:3001/api/actividad");

        const actividades = res.data.map((actividad) => {
          const fechaCompleta = new Date(actividad.FechaInicio);
          return {
            id: actividad.IdActividad,
            title: actividad.NombreActi,
            image: actividad.Imagen
              ? `http://localhost:3001/uploads/${actividad.Imagen}`
              : fondo4,
            applicant: actividad.Organizador || "SENA",
            location: actividad.Ubicacion,
            fullDate: fechaCompleta,
            date: fechaCompleta.toLocaleDateString('es-ES'),
            time: `${actividad.HoraInicio} - ${actividad.HoraFin}`,
            description: actividad.Descripcion,
            contact: "contacto@sena.edu.co",
            day: fechaCompleta.getDate(),
              asistio: false,
  feedbackDado: false,
          };
        });

        // Filtrar actividades del mes actual
        const mesActual = currentDate.getMonth();
        const añoActual = currentDate.getFullYear();
        const actividadesDelMes = actividades.filter((a) => {
          const fecha = a.fullDate;
          return fecha.getMonth() === mesActual && fecha.getFullYear() === añoActual;
        });

        // Guardar en estados
        setEvents(actividadesDelMes);
        setCalendarEvents(actividadesDelMes.map(a => ({
          day: a.day,
          title: a.title,
          eventId: a.id
        })));

      } catch (err) {
        console.error("Error cargando actividades:", err);
      }
    };

    fetchEventos();
  }, [currentDate]);

  // Alternar notificaciones
  const toggleNotifications = () => setShowNotifications(!showNotifications);

  // Mostrar modal con info del evento
  const openEventModal = (event) => {
    setSelectedEvent(event);
    setShowInfoModal(true);
    localStorage.setItem("lastSeenActividadId", event.id);
  };

  // Marcar como "vista" una notificación
  const handleNotificationClick = (eventId) => {
    setClickedNotifications((prev) =>
      prev.includes(eventId) ? prev.filter((id) => id !== eventId) : [...prev, eventId]
    );
  };
  const token = localStorage.getItem('token');

const confirmarAsistencia = async (eventoId) => {
  const IdUsuario = Number(localStorage.getItem("usuarioId"));
  const token = localStorage.getItem("token");

  try {
    await axios.post(
      'http://localhost:3001/api/relusuarioevento/confirmar-asistencia',
      {
        IdUsuario,
        IdEvento: eventoId
      },
      {
        headers: {
          Authorization: `Bearer ${token}`
        }
      }
    );

    alert("¡Ojo! Si no asistes tendrás una penalización , tendras un limite de uso de la plataforma.");

    const nuevosEventos = events.map(ev =>
      ev.id === eventoId ? { ...ev, asistio: true } : ev
    );
    setEvents(nuevosEventos);

    if (selectedEvent && selectedEvent.id === eventoId) {
      setSelectedEvent(prev => ({ ...prev, asistio: true }));
    }

  } catch (err) {
    console.error("Error al confirmar asistencia:", err);
    alert("Error al confirmar asistencia");
  }
};



  // Renderizar los días del calendario
  const renderCalendarDays = () => {
    const days = [];
    days.push(<div key="empty-1" className="dia-vacio"></div>);
    days.push(<div key="empty-2" className="dia-vacio"></div>);

    for (let i = 1; i <= 31; i++) {
      const event = calendarEvents.find((e) => e.day === i);
      const isToday = i === new Date().getDate() && currentDate.getMonth() === new Date().getMonth();
      if (event) {
        const fullEvent = events.find((e) => e.id === event.eventId);
        const isClicked = clickedNotifications.includes(fullEvent.id);
        days.push(
          <div key={`day-${i}`} className={`dia evento ${isToday ? 'hoy' : ''}`}>

            <div onClick={() => openEventModal(fullEvent)} className="dia-clickable">
              <span className="dia-numero">{i}</span>
              <span className="nombre-evento">{event.title}</span>
            </div>
            <FaBell
              className={`noti-icon ${isClicked ? 'clicked' : ''}`}
              onClick={() => handleNotificationClick(fullEvent.id)}
              title="Notificación"
            />
          </div>
        );
      } else {
        days.push(
          <div key={i} className="dia">
            <span className="dia-numero">{i}</span>
          </div>
        );
      }
    }
    return days;
  };

  return (
    <div className="admin-container">
      <main className="main-content">
        <header className="app-header">
          <h1 className="app-title">Calendario de Actividades y Eventos <span className="sena-text">SENA</span></h1>

          {/* Botón de notificaciones */}
          <button className={`notifications-btn ${showNotifications ? 'active' : ''}`} onClick={toggleNotifications}>
            <i className="bell-icon">🔔</i>
            <span className="notification-badge">{events.length}</span>
          </button>

          {/* Panel de notificaciones */}
          {showNotifications && (
            <div className="notifications-panel">
              <div className="notifications-header">
                <h2>Notificaciones</h2>
                <button className="close-notifications" onClick={toggleNotifications}>&times;</button>
              </div>
              <div className="notifications-list">
                {events.map((event) => (
                  <div
                    key={event.id}
                    className="notification-item"
                    onClick={() => {
                      openEventModal(event);
                      setShowNotifications(false);
                    }}
                  >
                    <img src={event.image} alt={event.title} className="notification-img" />
                    <div className="notification-content">
                      <h3>{event.title}</h3>
                      <p>{event.date} - {event.time}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </header>

        {/* Calendario principal */}
        <section className="calendar-section">
          
          <div className="calendar-container">
            <div className="calendar-controls">
              <button className="month-btn prev-month" onClick={irAlMesAnterior}>◀️</button>
              <h3 className="current-month">
                {currentDate.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' }).toUpperCase()}
              </h3>
              <button className="month-btn next-month" onClick={irAlMesSiguiente}>▶️</button>
            </div>
            <div className="calendar-grid">
              {['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'].map((day) => (
                <div key={day} className="week-day">{day}</div>
              ))}
              {renderCalendarDays()}
            </div>
          </div>
        </section>
      </main>

      {/* Modal informativo */}
      {showInfoModal && selectedEvent && (
        <div className="modal-overlay">
          <div className="event-modal-container">
            <button className="modal-close" onClick={() => setShowInfoModal(false)}>&times;</button>
            <h2 className="event-modal-title">{selectedEvent.title}</h2>
            <div className="event-modal-content">
              <img src={selectedEvent.image} alt={selectedEvent.title} className="event-modal-image" />
              <div className="event-details">
                <div className="event-participation">
  {!selectedEvent.asistio ? (
    <button className="btn-confirmar" onClick={() => confirmarAsistencia(selectedEvent.id)}>
      ✔ Asistiré
    </button>
  ) : (
    <span className="asistencia-confirmada">✅ Ya asististe</span>
  )}

  {!selectedEvent.feedbackDado && selectedEvent.asistio && (
    <button className="btn-feedback" onClick={() => setShowFeedback(true)}>
      💬 Dar feedback
    </button>
  )}
</div>
{showFeedback && (
  <div className="modal-overlay">
    <div className="event-modal-container">
      <button className="modal-close" onClick={() => setShowFeedback(false)}>&times;</button>
      <h2 className="event-modal-title">Feedback del evento</h2>
      <div className="event-modal-content">
        <label>Calificación (1-5):</label>
        <input
          type="number"
          min="1"
          max="5"
          value={feedbackRating}
          onChange={(e) => setFeedbackRating(Number(e.target.value))}
        />
        <label>Comentario:</label>
        <textarea
          rows="4"
          value={feedbackText}
          onChange={(e) => setFeedbackText(e.target.value)}
        />
        <button
          onClick={() => {
            // Aquí podrías enviar feedback al backend
            const nuevosEventos = events.map(ev =>
              ev.id === selectedEvent.id ? { ...ev, feedbackDado: true } : ev
            );
            setEvents(nuevosEventos);
            setSelectedEvent((prev) => ({ ...prev, feedbackDado: true }));
            setShowFeedback(false);
            setFeedbackText("");
            setFeedbackRating(5);
          }}
        >
          Enviar feedback
        </button>
      </div>
    </div>
  </div>
)}

                <p><strong>Fecha:</strong> {selectedEvent.date}</p>
                <p><strong>Hora:</strong> {selectedEvent.time}</p>
                <p><strong>Lugar:</strong> {selectedEvent.location}</p>
                <p><strong>Solicitante:</strong> {selectedEvent.applicant}</p>
                <p><strong>Contacto:</strong> {selectedEvent.contact}</p>
                <p>{selectedEvent.description}</p>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default CalendarioAp;
