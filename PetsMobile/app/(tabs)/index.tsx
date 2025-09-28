import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Appbar, useTheme } from 'react-native-paper';
import { SafeAreaView } from 'react-native-safe-area-context';
import PetsViewer from '../../src/components/PetsViewer';

const HomeScreen = () => {
  const theme = useTheme();

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <Appbar.Header
        theme={{ colors: { primary: theme.colors.surface } }}
        style={{ backgroundColor: theme.colors.surface }}
        accessibilityLabel="Main App Header"
      >
        <Appbar.Action
          icon="menu"
          onPress={() => console.log('Hamburger menu pressed')}
          accessibilityLabel="Open navigation menu"
        />
        <Appbar.Content title="Pets" accessibilityLabel="Pets, screen title" />
      </Appbar.Header>
      <View style={styles.content}>
        <PetsViewer />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    padding: 8,
  },
});

export default HomeScreen;