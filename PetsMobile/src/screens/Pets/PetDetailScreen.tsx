import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Image } from 'react-native';
import { getPetById } from '../../api/services/petService';
import { PetDTO } from '../../models/pet';

const PetDetailScreen = ({ route }: any) => {
  const { petId } = route.params;
  const [pet, setPet] = useState<PetDTO | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPet = async () => {
      try {
        const data = await getPetById(petId);
        setPet(data);
      } catch (e) {
        setError('Failed to fetch pet details.');
      } finally {
        setLoading(false);
      }
    };

    fetchPet();
  }, [petId]);

  if (loading) {
    return <ActivityIndicator size="large" style={styles.centered} />;
  }

  if (error || !pet) {
    return (
      <View style={styles.centered}>
        <Text>{error || 'Pet not found.'}</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Image source={{ uri: pet.imageUrl ?? 'https://via.placeholder.com/150' }} style={styles.image} />
      <Text style={styles.name}>{pet.name}</Text>
      <Text style={styles.detail}>Age: {pet.age}</Text>
      <Text style={styles.detail}>Color: {pet.color}</Text>
      <Text style={styles.detail}>Breed: {pet.breedName}</Text>
      <Text style={styles.description}>{pet.description}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: '100%',
    height: 200,
    borderRadius: 8,
    marginBottom: 16,
  },
  name: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  detail: {
    fontSize: 16,
    marginBottom: 4,
  },
  description: {
    fontSize: 16,
    marginTop: 16,
  },
});

export default PetDetailScreen;