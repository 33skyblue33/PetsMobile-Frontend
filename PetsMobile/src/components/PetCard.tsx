import React from 'react';
import { StyleSheet } from 'react-native';
import { Card, Text } from 'react-native-paper';
import { Pet } from '../types';

interface PetCardProps {
  pet: Pet;
  onPress: () => void;
}

const PetCard = ({ pet, onPress }: PetCardProps) => {
  return (
    <Card
      style={styles.card}
      onPress={onPress}
      accessibilityLabel={`View details for ${pet.name}`}
      accessibilityRole="button"
    >
      <Card.Cover source={{ uri: pet.imageUrl }} />
      <Card.Content style={styles.content}>
        <Text variant="titleMedium" numberOfLines={1}>{pet.name}</Text>
      </Card.Content>
    </Card>
  );
};

const styles = StyleSheet.create({
  card: {
    margin: 4,
    flex: 1,
  },
  content: {
    paddingVertical: 12,
    alignItems: 'center',
  }
});

export default PetCard;