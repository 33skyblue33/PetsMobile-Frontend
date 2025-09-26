import React from 'react';
import { View, Text, StyleSheet, Button, Alert } from 'react-native';
import useAuthStore from '../../src/state/authStore';
import { useRouter } from 'expo-router';
import apiClient from '../../src/api';

const ProfileScreen = () => {
  const { user, logout } = useAuthStore();
  const router = useRouter();

  const handleLogout = () => {
    logout();
    router.replace('/login');
  };

  const handleDeleteAccount = () => {
    Alert.alert(
      "Delete Account",
      "Are you sure you want to delete your account? This action is irreversible.",
      [
        { text: "Cancel", style: "cancel" },
        { text: "OK", onPress: async () => {
            try {
              await apiClient.delete(`/Users/${user.id}`);
              handleLogout();
            } catch (error) {
              Alert.alert("Error", "Failed to delete account.");
            }
          }
        }
      ]
    );
  };

  if (!user) {
    return (
      <View style={styles.container}>
        <Text>No user data available.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Profile</Text>
      <View style={styles.infoContainer}>
        <Text style={styles.label}>Name:</Text>
        <Text style={styles.value}>{user.name} {user.surname}</Text>
      </View>
      <View style={styles.infoContainer}>
        <Text style={styles.label}>Email:</Text>
        <Text style={styles.value}>{user.email}</Text>
      </View>
      <View style={styles.infoContainer}>
        <Text style={styles.label}>Age:</Text>
        <Text style={styles.value}>{user.age}</Text>
      </View>
      <View style={styles.actions}>
        <Button title="Edit Profile" onPress={() => router.push('/edit-profile')} />
        <Button title="Logout" onPress={handleLogout} color="orange" />
        <Button title="Delete Account" onPress={handleDeleteAccount} color="red" />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  infoContainer: {
    flexDirection: 'row',
    marginBottom: 10,
  },
  label: {
    fontWeight: 'bold',
    marginRight: 10,
  },
  value: {
    fontSize: 16,
  },
  actions: {
    marginTop: 30,
    gap: 10,
  }
});

export default ProfileScreen;