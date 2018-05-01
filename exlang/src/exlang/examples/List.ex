interface List<T> {
  void set!(int i, T elt);
  T get(int i);

  property setGet(int i, T elt)
   = set(i, elt).get(i) == elt;
}

