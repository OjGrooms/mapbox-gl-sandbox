import { LngLatLike } from 'mapbox-gl';

interface MapMarkerObj {
  lngLat: LngLatLike;
  popup?: string;
  id?: string;
}

interface MapPopupObj {
  popup: string;
}

export { MapMarkerObj, MapPopupObj };
