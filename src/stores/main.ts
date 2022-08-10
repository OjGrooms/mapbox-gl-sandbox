import { MapMarkerObj } from '@/types/map.interfaces';
import { defineStore } from 'pinia';

interface MainStoreState {
  mapToken: string;
  isMapOpen: boolean;
  mapMarkers: MapMarkerObj[];
}

export const useMainStore = defineStore('main', {
  state: (): MainStoreState => ({
    mapToken: '', // your token goes here
    isMapOpen: false,
    mapMarkers: [],
  }),
  actions: {
    setIsMapOpen(val: boolean): void {
      this.isMapOpen = val;
    },
    setMapMarker(val: MapMarkerObj[]): void {
      this.mapMarkers = val;
    },
    pushMapMarker(val: MapMarkerObj): void {
      this.mapMarkers.push(val);
    },
    setMapToken(val: string): void {
      this.mapToken = val;
    },
    clearMapMarkers(): void {
      this.mapMarkers = [];
    },
  },
});
