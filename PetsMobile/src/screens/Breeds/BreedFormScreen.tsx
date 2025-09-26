import React, { useState, useEffect } from 'react';
import { View, TextInput, Button, StyleSheet, Alert, Text } from 'react-native';
import { createBreed, getBreedById, updateBreed } from '../../api/services/breedService';
import { BreedRequest } from '../../models/breed';

const BreedFormScreen = ({ route, navigation }: any) => {
  const { breedId } = route.params || {};
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (breedId) {
      setLoading(true);
      getBreedById(breedId)
        .then(breed => {
          setName(breed.name ?? '');
          setDescription(breed.description ?? '');
        })
        .catch(() => Alert.alert('Error', 'Failed to load breed data.'))
        .finally(() => setLoading(false));
    }
  }, [breedId]);

  const handleSubmit = async () => {
    if (!name) {
      Alert.alert('Error', 'Please enter a name for the breed.');
      return;
    }

    const breedData: BreedRequest = {
      name,
      description,
    };

    setLoading(true);
    try {
      if (breedId) {
        await updateBreed(breedId, breedData);
        Alert.alert('Success', 'Breed updated successfully.');
      } else {
        await createBreed(breedData);
        Alert.alert('Success', 'Breed created successfully.');
      }
      navigation.goBack();
    } catch (error) {
      Alert.alert('Error', `Failed to ${breedId ? 'update' : 'create'} breed.`);
    } finally {
      setLoading(false);
    }
  };

  if (loading && breedId) {
    return <Text>Loading...</Text>;
  }

  return (
    <View style={styles.container}>
      <TextInput style={styles.input} placeholder="Breed Name" value={name} onChangeText={setName} />
      <TextInput style={styles.input} placeholder="Description" value={description} onChangeText={setDescription} multiline />
      <Button title={breedId ? 'Update Breed' : 'Create Breed'} onPress={handleSubmit} disabled={loading} />
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

export default BreedFormScreen;