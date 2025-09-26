import React from 'react';
import { ScrollView, Alert } from 'react-native';
import { Stack, useRouter } from 'expo-router';
import PetForm from '../../../src/components/PetForm';
import { PetRequest } from '../../../src/types';
import apiClient from '../../../src/api';

const CreatePetScreen = () => {
  const router = useRouter();

  const handleCreate = async (data: PetRequest) => {
    try {
      await apiClient.post('/Pets', data);
      router.back();
    } catch (error) {
      Alert.alert('Error', 'Failed to create pet.');
      console.error(error);
    }
  };

  return (
    <ScrollView>
      <Stack.Screen options={{ title: 'Create Pet' }} />
      <PetForm onSubmit={handleCreate} />
    </ScrollView>
  );
};

export default CreatePetScreen;