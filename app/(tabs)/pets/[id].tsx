import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Image, ScrollView, Button, Alert } from 'react-native';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import usePetStore from '../../../src/state/petStore';
import useAuthStore from '../../../src/state/authStore';
import { Pet } from '../../../src/types';
import apiClient from '../../../src/api';

const PetDetailScreen = () => {
  const { id } = useLocalSearchParams();
  const { getPetById } = usePetStore();
  const { user } = useAuthStore();
  const router = useRouter();

  const [pet, setPet] = useState<Pet | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchPet = async () => {
      const petData = await getPetById(Number(id));
      setPet(petData);
      setIsLoading(false);
    };
    fetchPet();
  }, [id]);

  const handleDelete = async () => {
    Alert.alert(
      "Delete Pet",
      "Are you sure you want to delete this pet?",
      [
        { text: "Cancel", style: "cancel" },
        { text: "OK", onPress: async () => {
            try {
              await apiClient.delete(`/Pets/${id}`);
              router.back();
            } catch (error) {
              Alert.alert("Error", "Failed to delete pet.");
            }
          }
        }
      ]
    );
  };

  if (isLoading) {
    return <ActivityIndicator size="large" style={styles.loader} />;
  }

  if (!pet) {
    return <Text>Pet not found.</Text>;
  }

  return (
    <ScrollView style={styles.container}>
      <Stack.Screen options={{ title: pet.name }} />
      <Image source={{ uri: pet.imageUrl }} style={styles.image} />
      <View style={styles.detailsContainer}>
        <Text style={styles.title}>{pet.name}</Text>
        <Text style={styles.subtitle}>{pet.breedName}</Text>
        <Text style={styles.detailText}>Color: {pet.color}</Text>
        <Text style={styles.detailText}>Age: {pet.age}</Text>
        <Text style={styles.description}>{pet.description}</Text>

        {user?.role === 'Employee' && (
          <View style={styles.adminActions}>
            <Button title="Edit" onPress={() => router.push(`/(tabs)/pets/edit/${id}`)} />
            <Button title="Delete" color="red" onPress={handleDelete} />
          </View>
        )}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  loader: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: '100%',
    height: 250,
  },
  detailsContainer: {
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  subtitle: {
    fontSize: 18,
    color: 'gray',
    marginBottom: 16,
  },
  detailText: {
    fontSize: 16,
    marginBottom: 8,
  },
  description: {
    fontSize: 16,
    marginTop: 8,
  },
  adminActions: {
    marginTop: 20,
    flexDirection: 'row',
    justifyContent: 'space-around',
  }
});

export default PetDetailScreen;