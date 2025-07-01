import { Table, Column, Model, DataType, ForeignKey, BelongsTo } from 'sequelize-typescript';
import { Usuario } from './Usuario';
import { RolUsuario } from './RolUsuario';

@Table({ tableName: 'Aprendiz' })
export class Aprendiz extends Model {
  @ForeignKey(() => Usuario)
  @Column
  declare IdUsuario: number;

  @ForeignKey(() => RolUsuario)
  @Column
  declare IdRolUsuario: number;

  @Column({ type: DataType.STRING })
  declare Ficha: string;

  @Column({ type: DataType.STRING })
  declare Jornada: string;

  @Column({ type: DataType.STRING })
  declare ProgramaFormacion: string;

  @BelongsTo(() => Usuario)
  declare usuario: Usuario;

  @BelongsTo(() => RolUsuario)
  declare rolUsuario: RolUsuario;
}
