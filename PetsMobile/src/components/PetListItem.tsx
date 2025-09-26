import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';
import { PetDTO } from '../models/pet';

interface PetListItemProps {
  pet: PetDTO;
  onPress: () => void;
}

const PetListItem: React.FC<PetListItemProps> = ({ pet, onPress }) => {
  return (
    <TouchableOpacity onPress={onPress} style={styles.container}>
      <Image source={{ uri: pet.imageUrl ?? 'https://via.placeholder.com/150' }} style={styles.image} />
      <View style={styles.infoContainer}>
        <Text style={styles.name}>{pet.name}</Text>
        <Text>{pet.breedName}</Text>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
    alignItems: 'center',
  },
  image: {
    width: 80,
    height: 80,
    borderRadius: 40,
    marginRight: 10,
  },
  infoContainer: {
    flex: 1,
  },
  name: {
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default PetListItem;