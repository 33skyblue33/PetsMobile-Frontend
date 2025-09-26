import React, { useEffect, useState } from 'react';
import { ScrollView, Alert, Text, ActivityIndicator } from 'react-native';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import PetForm from '../../../src/components/PetForm';
import { PetRequest, Pet } from '../../../src/types';
import apiClient from '../../../src/api';
import usePetStore from '../../../src/state/petStore';

const EditPetScreen = () => {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const { getPetById } = usePetStore();

  const [initialData, setInitialData] = useState<PetRequest | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchPet = async () => {
      const petData: Pet = await getPetById(Number(id));
      if (petData) {
        // The backend does not provide breedId in PetDTO.
        // The user must manually enter it for the update to succeed.
        setInitialData({
          name: petData.name,
          color: petData.color,
          age: petData.age,
          imageUrl: petData.imageUrl,
          description: petData.description,
          breedId: 0, // Placeholder
        });
      }
      setIsLoading(false);
    };
    fetchPet();
  }, [id]);

  const handleUpdate = async (data: PetRequest) => {
    if (data.breedId === 0) {
      Alert.alert("Missing Breed ID", "Please enter a valid Breed ID to update the pet.");
      return;
    }
    try {
      await apiClient.put(`/Pets/${id}`, data);
      router.back();
    } catch (error) {
      Alert.alert('Error', 'Failed to update pet.');
      console.error(error);
    }
  };

  if (isLoading) {
    return <ActivityIndicator size="large" />;
  }

  if (!initialData) {
    return <Text>Pet not found or failed to load.</Text>;
  }

  return (
    <ScrollView>
      <Stack.Screen options={{ title: 'Edit Pet' }} />
      <PetForm onSubmit={handleUpdate} initialData={initialData} isEdit={true} />
    </ScrollView>
  );
};

export default EditPetScreen;