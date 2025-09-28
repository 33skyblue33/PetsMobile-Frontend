import React, { useEffect, useState } from 'react';
import { View, FlatList, StyleSheet, ActivityIndicator } from 'react-native';
import { Text } from 'react-native-paper';
import { Pet } from '../types';
import PetCard from './PetCard';
import PetDetailsModal from './PetDetailsModal';
import { getAllPets } from '@api/pets';

const PetsViewer = () => {
  const [pets, setPets] = useState<Pet[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedPet, setSelectedPet] = useState<Pet | null>(null);
  const [isModalVisible, setIsModalVisible] = useState(false);

  useEffect(() => {
    const fetchPets = async () => {
      try {
        setLoading(true);
        const fetchedPets = await getAllPets();
        setPets(fetchedPets);
        setError(null);
      } catch (e) {
        setError('Failed to fetch pets. Please try again later.');
        console.error(e);
      } finally {
        setLoading(false);
      }
    };

    fetchPets();
  }, []);

  const handleCardPress = (pet: Pet) => {
    setSelectedPet(pet);
    setIsModalVisible(true);
  };

  const handleDismissModal = () => {
    setIsModalVisible(false);
    setSelectedPet(null);
  };

  if (loading) {
    return <ActivityIndicator size="large" style={styles.centered} />;
  }

  if (error) {
    return (
      <View style={styles.centered}>
        <Text>{error}</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <FlatList
        data={pets}
        renderItem={({ item }) => <PetCard pet={item} onPress={() => handleCardPress(item)} />}
        keyExtractor={(item) => item.id.toString()}
        numColumns={2}
        contentContainerStyle={styles.list}
      />
      <PetDetailsModal
        pet={selectedPet}
        visible={isModalVisible}
        onDismiss={handleDismissModal}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  list: {
    padding: 4,
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default PetsViewer;