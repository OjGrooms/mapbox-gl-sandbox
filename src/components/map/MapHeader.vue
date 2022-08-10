<script setup lang="ts">
  import { computed, ref, watch } from 'vue';
  import FormSelect from '@/components/form/FormSelect.vue';
  import type { SelectOptions } from '@/types/form.interfaces';
  import FormInput from '../form/FormInput.vue';

  interface MapHeaderProps {
    mapEntities: SelectOptions[];
    filterOptions?: SelectOptions[];
    tokenSubmitted: boolean;
  }

  const props = defineProps<MapHeaderProps>();

  const emit = defineEmits<{
    (e: 'resetMap'): void;
    (e: 'openMap'): void;
    (e: 'entitySelected', entity: string): void;
    (e: 'tokenSubmitted', token: string): void;
  }>();

  const entityModel = ref<string>('');
  const token = ref<string>('');

  const tokenInvalid = computed((): boolean => token.value === '');
  const tokenInvalidMessage = computed((): string => {
    let helpText = '';
    if (tokenInvalid) {
      helpText = 'You need to input your token for the map to work';
    }
    return helpText;
  });

  const submitToken = (): void => {
    if (token.value) {
      emit('tokenSubmitted', token.value);
    }
  };

  const entitySelected = (entity: string): void => {
    emit('entitySelected', entity);
  };

  const resetMap = (): void => {
    entityModel.value = '';
    emit('resetMap');
  };

  const openMap = (): void => {
    emit('openMap');
  };

  watch(
    () => entityModel.value,
    () => {
      entitySelected(entityModel.value);
    }
  );
</script>

<template>
  <article class="panel is-info">
    <div class="panel-heading">
      <div class="columns">
        <div class="column">Map Actions</div>
      </div>
    </div>

    <div class="panel-block">
      <div class="columns">
        <div class="column">
          <FormSelect
            v-model="entityModel"
            :selectLabel="'Entity'"
            :selectOptions="mapEntities"
          />
          <FormInput
            v-model="token"
            :inputLabel="'Your Mapbox Token'"
            :inputPlaceholder="'Token'"
            :isInvalid="tokenInvalid"
            :invalidMessage="tokenInvalidMessage"
            :inputType="'password'"
          />
          <button
            class="button is-outlined"
            :class="
              ({ 'is-danger': tokenInvalid }, { 'is-link': !tokenInvalid })
            "
            @click="submitToken"
          >
            Submit
          </button>
        </div>
        <div class="column"></div>
        <div class="column"></div>
      </div>
    </div>

    <div v-if="tokenSubmitted" class="panel-block panel-footer">
      <button class="button is-link is-outlined" @click="openMap">
        Open Map
      </button>
      <button class="button is-link is-outlined" @click="resetMap">
        Reset
      </button>
    </div>
  </article>
</template>

<style lang="scss" scoped>
  @import '@/styles/app.scss';
  .panel {
    overflow: auto;
  }
  .panel-footer {
    background-color: $very-light-blue-gray;
    height: 40px;
    width: 100%;
  }

  .columns {
    width: 100%;
  }
</style>
