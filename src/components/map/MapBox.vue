import { onMounted } from '@vue/runtime-core/dist/runtime-core';
<script setup lang="ts">
  import { ref, watch, onMounted } from 'vue';
  import mapboxgl, { LngLatLike, MapboxEvent } from 'mapbox-gl';
  import 'mapbox-gl/dist/mapbox-gl.css';
  import type { MapMarkerObj } from '@/types/map.interfaces';

  interface MapProps {
    show?: boolean;
    accessToken: string;
    markers: MapMarkerObj[];
  }

  const props = withDefaults(defineProps<MapProps>(), {
    show: false,
  });

  const emit = defineEmits<{
    (e: 'dismissClick'): void;
  }>();

  mapboxgl.accessToken = props.accessToken ?? '';
  const isFirstLoad = ref<boolean>(true);
  const map = ref<mapboxgl.Map>();
  const mapMarkers = ref<Array<mapboxgl.Marker>>([]);
  const mapPopups = ref<Array<mapboxgl.Popup>>([]);

  // Adding a marker to the map, with popup if present.
  const addMarker = (mapMarkerObj: MapMarkerObj): void => {
    const marker = new mapboxgl.Marker();
    const lngLat: LngLatLike = mapMarkerObj.lngLat;
    const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(
      mapMarkerObj.popup ?? ''
    );
    popup.setHTML(mapMarkerObj.popup ?? '');
    mapMarkers.value.push(marker);
    mapPopups.value.push(popup);
    marker.setLngLat(lngLat);
    marker.setPopup(popup);
    if (map.value) {
      marker.addTo(map.value);
      map.value.flyTo({
        center: lngLat,
        zoom: 12,
        speed: 1.5,
        curve: 1,
      });
    }
  };

  // Removing all the markers and popups from the map.
  const clearMarkers = (): void => {
    for (let i = 0; i < mapMarkers.value.length; i += 1) {
      mapMarkers.value[i].remove();
    }
    for (let i = 0; i < mapPopups.value.length; i += 1) {
      mapPopups.value[i].remove();
    }
    mapMarkers.value = [];
    mapPopups.value = [];
  };

  const dismissClick = (): void => {
    emit('dismissClick');
  };
  const updateMarkers = (): void => {
    clearMarkers();
    if (props.markers) {
      for (let i = 0; i < props.markers.length; i += 1) {
        const mapMarkerObj: MapMarkerObj = props.markers[i] as MapMarkerObj;
        addMarker(mapMarkerObj);
      }
    }
  };

  // Initializing the map.
  const initMap = (): void => {
    map.value = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [169.1445, -52.545],
      trackResize: true,
      zoom: 12,
    });
    map.value.on('idle', (e: MapboxEvent) => {
      e.target.resize(); // disable this line to stop auto resizing
      if (isFirstLoad.value) {
        isFirstLoad.value = false;
        updateMarkers();
      }
    });
  };

  watch(
    () => props.markers,
    () => {
      if (!isFirstLoad.value) {
        updateMarkers();
      }
      if (props.markers.length === 0 && map.value) {
        map.value.jumpTo({
          center: [169.1445, -52.545],
          zoom: 12,
        });
      }
    },
    { deep: true }
  );

  watch(
    () => props.show,
    () => {
      if (props.show && isFirstLoad.value) {
        initMap();
      }
      if (props.show) {
        setTimeout(() => {
          if (map.value) {
            map.value.resize(); // disable this line to stop auto resizing
          }
        }, 10);
      }
    }
  );
</script>

<template>
  <div class="modal" :class="{ 'is-active': show }">
    <div class="modal-background"></div>
    <div class="modal-content">
      <div id="map"></div>
    </div>
    <button
      class="modal-close is-large"
      aria-label="close"
      @click="dismissClick"
    ></button>
  </div>
</template>

<style lang="scss" scoped>
  @import '@/styles/app.scss';
  .modal-content {
    background-color: #4a4a4a;
    width: 95%;
    height: 95%;
    border-radius: 10px;
  }
  #map {
    width: 100%;
    height: 100%;
  }
</style>
