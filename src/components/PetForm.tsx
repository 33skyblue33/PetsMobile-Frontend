import React, { useState, useEffect } from 'react';
import { View, TextInput, Button, StyleSheet, Alert } from 'react-native';
import { PetRequest } from '../types';

interface PetFormProps {
  initialData?: PetRequest;
  onSubmit: (data: PetRequest) => void;
  isEdit?: boolean;
}

const PetForm: React.FC<PetFormProps> = ({ initialData, onSubmit, isEdit = false }) => {
  const [name, setName] = useState('');
  const [color, setColor] = useState('');
  const [age, setAge] = useState('');
  const [imageUrl, setImageUrl] = useState('');
  const [description, setDescription] = useState('');
  const [breedId, setBreedId] = useState('');

  useEffect(() => {
    if (initialData) {
      setName(initialData.name);
      setColor(initialData.color);
      setAge(String(initialData.age));
      setImageUrl(initialData.imageUrl);
      setDescription(initialData.description);
      setBreedId(String(initialData.breedId));
    }
  }, [initialData]);

  const handleSubmit = () => {
    if (!name || !color || !age || !breedId) {
      Alert.alert('Validation Error', 'Please fill in all required fields.');
      return;
    }
    onSubmit({
      name,
      color,
      age: parseInt(age, 10),
      imageUrl,
      description,
      breedId: parseInt(breedId, 10),
    });
  };

  return (
    <View style={styles.container}>
      <TextInput style={styles.input} placeholder="Name" value={name} onChangeText={setName} />
      <TextInput style={styles.input} placeholder="Color" value={color} onChangeText={setColor} />
      <TextInput style={styles.input} placeholder="Age" value={age} onChangeText={setAge} keyboardType="numeric" />
      <TextInput style={styles.input} placeholder="Image URL" value={imageUrl} onChangeText={setImageUrl} />
      <TextInput style={styles.input} placeholder="Description" value={description} onChangeText={setDescription} multiline />
      <TextInput style={styles.input} placeholder="Breed ID" value={breedId} onChangeText={setBreedId} keyboardType="numeric" />
      <Button title={isEdit ? 'Update Pet' : 'Create Pet'} onPress={handleSubmit} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 12,
    paddingHorizontal: 8,
  },
});

export default PetForm;