<script setup lang="ts">
  import MapHeader from '@/components/map/MapHeader.vue';
  import { MapMarkerObj } from '@/types/map.interfaces';
  import type { SelectOptions } from '@/types/form.interfaces';
  import { watch, ref, computed } from 'vue';
  import { useMainStore } from '@/stores/main';
  const mainStore = useMainStore();

  const markerSelectOptions: SelectOptions[] = [
    {
      data: '',
      label: 'Select a location',
    },
    {
      data: '1',
      label: 'location 1',
    },
    {
      data: '2',
      label: 'location 2',
    },
    {
      data: '3',
      label: 'location 3',
    },
    {
      data: '4',
      label: 'location 4',
    },
  ];

  const locations: Array<MapMarkerObj> = [
    {
      lngLat: [107.84992, 33.9712],
      popup: 'Location 1',
      id: '1',
    },
    {
      lngLat: [9.62088, 9.38173],
      popup: 'Location 2',
      id: '2',
    },
    {
      lngLat: [141.83557, 43.86557],
      popup: 'Location 3',
      id: '3',
    },
    {
      lngLat: [-65.15342, -7.76055],
      popup: 'Location 4',
      id: '4',
    },
  ];

  const entitySelected = (entity: string): void => {
    mainStore.clearMapMarkers();
    console.log('selecting entity in app');
    let foundLocation = locations.find((loc) => loc.id === entity);
    if (foundLocation) {
      mainStore.pushMapMarker(foundLocation);
      openMap();
    }
  };

  const tokenSubmitted = (token: string): void => {
    mainStore.setMapToken(token);
  };
  const tokenWasSubmitted = computed((): boolean => mainStore.mapToken !== '');

  const resetMap = (): void => {
    mainStore.clearMapMarkers();
  };

  const openMap = (): void => {
    mainStore.setIsMapOpen(true);
  };
</script>

<template>
  <div id="Map" class="container is-fluid">
    <div class="columns">
      <div class="column">
        <section class="section">
          <MapHeader
            :mapEntities="markerSelectOptions"
            :tokenSubmitted="tokenWasSubmitted"
            @tokenSubmitted="tokenSubmitted"
            @entitySelected="entitySelected"
            @openMap="openMap"
            @resetMap="resetMap"
          />
        </section>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  @import '@/styles/app.scss';

  .columns {
    height: 100%;
    .column {
      height: inherit;
    }
  }
  .map-container {
    height: 90%;
  }
  .map-panel {
    height: inherit;
    background: transparent;
  }
  .container {
    height: 90%;
  }
  #Map {
    width: 95%;
  }
</style>
