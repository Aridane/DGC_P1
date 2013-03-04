interface Drawable {
  int type();
  void draw(float k, boolean [] options);
  boolean closed();
  PVector getCentroid();
  int triangles();
  void applyPerspective(float k);
}
