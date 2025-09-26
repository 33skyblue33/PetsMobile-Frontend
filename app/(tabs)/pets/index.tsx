import React, { useEffect } from 'react';
import { View, Text, FlatList, StyleSheet, ActivityIndicator, RefreshControl, TouchableOpacity } from 'react-native';
import usePetStore from '../../../src/state/petStore';
import useAuthStore from '../../../src/state/authStore';
import { Link, Stack } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';

const PetsListScreen = () => {
  const { pets, isLoading, fetchPets } = usePetStore();
  const { user } = useAuthStore();

  useEffect(() => {
    fetchPets();
  }, []);

  const renderPetItem = ({ item }) => (
    <Link href={`/(tabs)/pets/${item.id}`} asChild>
      <TouchableOpacity style={styles.itemContainer}>
        <Text style={styles.itemText}>{item.name}</Text>
        <Text>{item.breedName}</Text>
      </TouchableOpacity>
    </Link>
  );

  return (
    <View style={styles.container}>
      <Stack.Screen options={{ title: 'Pets' }} />
      {isLoading && pets.length === 0 ? (
        <ActivityIndicator size="large" style={styles.loader} />
      ) : (
        <FlatList
          data={pets}
          renderItem={renderPetItem}
          keyExtractor={(item) => item.id.toString()}
          refreshControl={<RefreshControl refreshing={isLoading} onRefresh={fetchPets} />}
        />
      )}
      {user?.role === 'Employee' && (
        <Link href="/(tabs)/pets/create" asChild>
          <TouchableOpacity style={styles.fab}>
            <Ionicons name="add" size={30} color="white" />
          </TouchableOpacity>
        </Link>
      )}
    </View>
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
  itemContainer: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  itemText: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  fab: {
    position: 'absolute',
    right: 30,
    bottom: 30,
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: 'blue',
    justifyContent: 'center',
    alignItems: 'center',
    elevation: 8,
  },
});

export default PetsListScreen;