import React from 'react';
import { StyleSheet, ScrollView } from 'react-native';
import { Modal, Card, Text, Divider, useTheme } from 'react-native-paper';
import { Pet } from '../types';

interface PetDetailsModalProps {
  pet: Pet | null;
  visible: boolean;
  onDismiss: () => void;
}

const PetDetailsModal = ({ pet, visible, onDismiss }: PetDetailsModalProps) => {
  const theme = useTheme();

  if (!pet) {
    return null;
  }

  return (
    <Modal
      visible={visible}
      onDismiss={onDismiss}
      contentContainerStyle={[styles.modalContainer, { backgroundColor: theme.colors.surface }]}
      accessibilityLabel={`Details for ${pet.name}`}
      accessibilityViewIsModal={true}
    >
      <ScrollView>
        <Card style={styles.card}>
          <Card.Cover source={{ uri: pet.imageUrl }} />
          <Card.Title
            title={pet.name}
            subtitle={`Age: ${pet.age} | Color: ${pet.color}`}
            titleVariant="headlineMedium"
            subtitleVariant="bodyMedium"
          />
          <Card.Content>
            <Text variant="titleMedium" style={styles.sectionTitle}>Breed</Text>
            <Text variant="bodyLarge">{pet.breedName}</Text>
            <Text variant="bodyMedium" style={styles.breedDescription}>{pet.breedDescription}</Text>
            <Divider style={styles.divider} />
            <Text variant="titleMedium" style={styles.sectionTitle}>About</Text>
            <Text variant="bodyLarge">{pet.description}</Text>
          </Card.Content>
        </Card>
      </ScrollView>
    </Modal>
  );
};

const styles = StyleSheet.create({
  modalContainer: {
    padding: 20,
    margin: 20,
    borderRadius: 8,
  },
  card: {
    elevation: 0, // Modal provides elevation
  },
  sectionTitle: {
    marginTop: 16,
    marginBottom: 8,
  },
  breedDescription: {
    marginTop: 4,
    fontStyle: 'italic'
  },
  divider: {
    marginVertical: 16,
  },
});

export default PetDetailsModal;