import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import PetListScreen from '../screens/Pets/PetListScreen';
import PetDetailScreen from '../screens/Pets/PetDetailScreen';
import PetFormScreen from '../screens/Pets/PetFormScreen';
import BreedFormScreen from '../screens/Breeds/BreedFormScreen';
import { Button } from 'react-native';

const Stack = createNativeStackNavigator();

const MainStack = () => {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="PetList"
        component={PetListScreen}
        options={({ navigation }) => ({
          title: 'Pets',
          headerRight: () => (
            <Button
              onPress={() => navigation.navigate('PetForm')}
              title="Add Pet"
            />
          ),
        })}
      />
      <Stack.Screen name="PetDetail" component={PetDetailScreen} options={{ title: 'Pet Details' }} />
      <Stack.Screen name="PetForm" component={PetFormScreen} options={{ title: 'Pet Form' }} />
      <Stack.Screen
        name="BreedForm"
        component={BreedFormScreen}
        options={{ title: 'Breed Form' }}
      />
    </Stack.Navigator>
  );
};

export default MainStack;