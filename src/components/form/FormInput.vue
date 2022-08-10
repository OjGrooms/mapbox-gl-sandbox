<script setup lang="ts">
  interface FormInputProps {
    autocomplete?: string;
    spellcheck?: boolean;
    fieldId?: string;
    inputLabel?: string;
    isDisabled?: boolean;
    inputPlaceholder?: string;
    inputType?: string;
    invalidMessage?: string;
    helperMessage?: string;
    isInvalid?: boolean;
    modelValue: string | number;
  }

  const props = withDefaults(defineProps<FormInputProps>(), {
    autocomplete: '',
    spellcheck: true,
    fieldId: '',
    inputLabel: 'Label',
    isDisabled: false,
    inputPlaceholder: '',
    inputType: 'text',
    invalidMessage: '',
    isInvalid: false,
  });

  const emit = defineEmits<{
    (e: 'update:modelValue', targetValue: string): void;
    (e: 'input-blur'): void;
  }>();

  const inputBlur = (): void => {
    emit('input-blur');
  };

  const inputChanged = (event: Event): void => {
    if (event.target) {
      const { target } = event;
      const targetValue = (target as HTMLFormElement).value;
      emit('update:modelValue', targetValue);
    }
  };
</script>

<template>
  <div class="field is-horizontal">
    <label class="field-label is-medium" data-test="form_input_label"
      >{{ inputLabel }}:</label
    >
    <div class="field-body">
      <div class="field">
        <fieldset :disabled="isDisabled">
          <p class="control" data-test="form_input_input">
            <input
              :id="fieldId"
              class="input is-medium"
              :class="{
                'is-danger': isInvalid,
              }"
              :type="inputType"
              :placeholder="inputPlaceholder"
              :value="modelValue"
              :spellcheck="spellcheck"
              :autocomplete="autocomplete"
              @blur="inputBlur"
              @input="inputChanged"
            />
          </p>
        </fieldset>
        <p
          v-if="isInvalid"
          class="help is-danger"
          data-test="form_input_invalid_message"
        >
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
</template>

<style lang="scss" scoped>
  @import '@/styles/app.scss';
</style>
