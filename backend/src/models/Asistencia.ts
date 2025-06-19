import {
  Table,
  Column,
  Model,
  DataType,
  ForeignKey,
  BelongsTo,
} from 'sequelize-typescript';
import { Usuario } from './Usuario';
import { Actividad } from './Actividad';

@Table({ tableName: 'Asistencia', timestamps: true })
export class Asistencia extends Model {
  @Column({ primaryKey: true, autoIncrement: true })
  declare AsiId: number;

  @Column({ type: DataType.DATE, allowNull: false })
  declare AsiFecha: Date;

  @Column({ type: DataType.INTEGER, allowNull: true })
  declare AsiHorasAsistidas: number;

 @Column({ type: DataType.DATE, allowNull: true })
declare QREntrada: Date;

@Column({ type: DataType.DATE, allowNull: true })
declare QRSalida: Date;

  @Column({ type: DataType.STRING(20), allowNull: false })
  declare tipo: string;

  @Column({ type: DataType.BOOLEAN, allowNull: true })
  declare AsiEntrada: boolean;

  @Column({ type: DataType.DATE, allowNull: true })
  declare AsiHoraEntrada: Date;

  @Column({ type: DataType.STRING(20), allowNull: true, defaultValue: 'Incompleta' })
declare AsiEstado: string;

 
  @ForeignKey(() => Usuario)
  @Column({ type: DataType.INTEGER, allowNull: false })
  declare IdUsuario: number;

  @BelongsTo(() => Usuario)
  declare usuario: Usuario;

  
  @ForeignKey(() => Actividad)
  @Column({ type: DataType.INTEGER, allowNull: false })
  declare IdActividad: number;

  @BelongsTo(() => Actividad)
  declare actividad: Actividad;

 
  @ForeignKey(() => Usuario)
  @Column({ type: DataType.INTEGER, allowNull: true })
  declare IdRegistradorEntrada: number;

  @BelongsTo(() => Usuario, { foreignKey: 'IdRegistradorEntrada', as: 'RegistradorEntrada' })
  declare RegistradorEntrada: Usuario;

  
  @ForeignKey(() => Usuario)
  @Column({ type: DataType.INTEGER, allowNull: true })
  declare IdRegistradorSalida: number;

  @BelongsTo(() => Usuario, { foreignKey: 'IdRegistradorSalida', as: 'RegistradorSalida' })
  declare RegistradorSalida: Usuario;
}
