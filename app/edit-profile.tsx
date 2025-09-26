import React, { useState } from 'react';
import { View, TextInput, Button, StyleSheet, Alert, ScrollView } from 'react-native';
import useAuthStore from '../src/state/authStore';
import { useRouter, Stack } from 'expo-router';
import { UserRequest } from '../src/types';
import apiClient from '../src/api';

const EditProfileScreen = () => {
  const { user, login } = useAuthStore();
  const router = useRouter();

  const [name, setName] = useState(user?.name || '');
  const [surname, setSurname] = useState(user?.surname || '');
  const [age, setAge] = useState(String(user?.age || ''));
  const [email, setEmail] = useState(user?.email || '');
  const [password, setPassword] = useState('');

  const handleUpdate = async () => {
    if (!user) return;

    const updatedData: UserRequest = {
      name,
      surname,
      age: parseInt(age, 10),
      email,
      password: password || undefined,
    };

    try {
      await apiClient.put(`/Users/${user.id}`, updatedData);
      // Re-login to get a new token with updated user info
      await login({ email: updatedData.email, password: password || "password" });
      Alert.alert('Success', 'Profile updated successfully.');
      router.back();
    } catch (error) {
      Alert.alert('Error', 'Failed to update profile.');
      console.error(error);
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Stack.Screen options={{ title: 'Edit Profile' }} />
      <View style={styles.form}>
        <TextInput style={styles.input} placeholder="Name" value={name} onChangeText={setName} />
        <TextInput style={styles.input} placeholder="Surname" value={surname} onChangeText={setSurname} />
        <TextInput style={styles.input} placeholder="Age" value={age} onChangeText={setAge} keyboardType="numeric" />
        <TextInput style={styles.input} placeholder="Email" value={email} onChangeText={setEmail} keyboardType="email-address" autoCapitalize="none" />
        <TextInput style={styles.input} placeholder="New Password (optional)" value={password} onChangeText={setPassword} secureTextEntry />
        <Button title="Update Profile" onPress={handleUpdate} />
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  form: {
    padding: 16,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 12,
    paddingHorizontal: 8,
  },
});

export default EditProfileScreen;