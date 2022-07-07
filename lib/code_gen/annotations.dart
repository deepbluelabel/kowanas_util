class ModelGen {
  const ModelGen();
}

const ModelObject = ModelGen();

// It's serializable class created by myself.
// It has same interfaces of model like toJson, ==.
class Generated{
  const Generated();
}

const generated = Generated();

// It's an enum type which is created by myself.
// It has different interfaces for serialization.
class Enumulated {
  const Enumulated();
}

const enumulated = Enumulated();

// It's comparator field of model.
// Operator == does not mean that all fieds are same.
// I want It works for specific fields what I defined.
class Comparator {
  const Comparator();
}

const comparator = Comparator();

// It's required field.
// This field has 'final'.
class Fixed {
  const Fixed();
}

const fixed = Fixed();