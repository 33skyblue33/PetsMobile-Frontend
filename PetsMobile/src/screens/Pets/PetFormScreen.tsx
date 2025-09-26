import React, { useState, useEffect } from 'react';
import { View, TextInput, Button, StyleSheet, Alert, Text } from 'react-native';
import { createPet, getPetById, updatePet } from '../../api/services/petService';
import { PetRequest } from '../../models/pet';

const PetFormScreen = ({ route, navigation }: any) => {
  const { petId } = route.params || {};
  const [name, setName] = useState('');
  const [color, setColor] = useState('');
  const [age, setAge] = useState('');
  const [imageUrl, setImageUrl] = useState('');
  const [description, setDescription] = useState('');
  const [breedId, setBreedId] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (petId) {
      setLoading(true);
      getPetById(petId)
        .then(pet => {
          setName(pet.name ?? '');
          setColor(pet.color ?? '');
          setAge(pet.age.toString());
          setImageUrl(pet.imageUrl ?? '');
          setDescription(pet.description ?? '');
          // Note: breedId is not part of PetDTO, this needs to be handled
          // For now, we'll leave it blank when editing. A real app would need a breed picker.
        })
        .catch(() => Alert.alert('Error', 'Failed to load pet data.'))
        .finally(() => setLoading(false));
    }
  }, [petId]);

  const handleSubmit = async () => {
    if (!name || !age || !breedId) {
      Alert.alert('Error', 'Please fill in all required fields.');
      return;
    }

    const petData: PetRequest = {
      name,
      color,
      age: parseInt(age, 10),
      imageUrl,
      description,
      breedId: parseInt(breedId, 10),
    };

    setLoading(true);
    try {
      if (petId) {
        await updatePet(petId, petData);
        Alert.alert('Success', 'Pet updated successfully.');
      } else {
        await createPet(petData);
        Alert.alert('Success', 'Pet created successfully.');
      }
      navigation.goBack();
    } catch (error) {
      Alert.alert('Error', `Failed to ${petId ? 'update' : 'create'} pet.`);
    } finally {
      setLoading(false);
    }
  };

  if (loading && petId) {
    return <Text>Loading...</Text>;
  }

  return (
    <View style={styles.container}>
      <TextInput style={styles.input} placeholder="Name" value={name} onChangeText={setName} />
      <TextInput style={styles.input} placeholder="Color" value={color} onChangeText={setColor} />
      <TextInput style={styles.input} placeholder="Age" value={age} onChangeText={setAge} keyboardType="numeric" />
      <TextInput style={styles.input} placeholder="Image URL" value={imageUrl} onChangeText={setImageUrl} />
      <TextInput style={styles.input} placeholder="Description" value={description} onChangeText={setDescription} multiline />
      <TextInput style={styles.input} placeholder="Breed ID" value={breedId} onChangeText={setBreedId} keyboardType="numeric" />
      <Button title={petId ? 'Update Pet' : 'Create Pet'} onPress={handleSubmit} disabled={loading} />
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

export default PetFormScreen;