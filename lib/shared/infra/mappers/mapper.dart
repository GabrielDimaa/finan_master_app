abstract interface class Mapper<E, M> {
  E toEntity(M model);

  M fromEntity(E entity);
}
