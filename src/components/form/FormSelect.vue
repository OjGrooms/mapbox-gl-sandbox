<script setup lang="ts">
  import type { SelectOptions } from '@/types/form.interfaces';

  interface FormSelectProps {
    selectLabel?: string;
    selectOptions: SelectOptions[];
    isDisabled?: boolean;
    isInvalid?: boolean;
    invalidMessage?: string;
    helperMessage?: string;
    isSmall?: boolean;
    modelValue: string;
  }

  const props = withDefaults(defineProps<FormSelectProps>(), {
    selectLabel: '',
    isDisabled: false,
    isInvalid: false,
    invalidMessage: 'text',
    isSmall: false,
  });

  const emit = defineEmits<{
    (e: 'update:modelValue', targetValue: string): void;
  }>();

  const selectChanged = (event: Event): void => {
    if (event.target) {
      const { target } = event;
      const targetValue = (target as HTMLFormElement).value;
      emit('update:modelValue', targetValue);
    }
  };
</script>

<template>
  <div class="field is-horizontal">
    <label v-if="selectLabel" class="field-label is-medium"
      >{{ selectLabel }}:</label
    >
    <div class="field-body">
      <div class="field is-narrow" :class="{ 'is-small': isSmall }">
        <div class="control">
          <div
            class="select is-fullwidth is-medium"
            :class="{
              'is-danger': isInvalid,
            }"
          >
            <select :disabled="isDisabled" @change="selectChanged">
              <option
                v-for="(selectOption, index) in selectOptions"
                :key="index"
                :value="selectOption.data"
                :selected="modelValue == selectOption.data"
              >
                {{ selectOption.label }}
              </option>
            </select>
          </div>
          <p v-if="isInvalid" class="help is-danger">
            {{ invalidMessage }}
          </p>
          <p
            v-if="helperMessage"
            class="help is-info"
            data-test="form_input_helper_message"
          >
            {{ helperMessage }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  @import '@/styles/app.scss';

  .is-small {
    width: 100%;
    .select {
      font-size: 12px;
    }
  }
</style>
