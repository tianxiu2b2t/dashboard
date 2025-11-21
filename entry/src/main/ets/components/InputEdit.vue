<template>
    <div
        :class="['relative w-full inputbox', wrapperClass, { active: effect }]"
    >
        <label
            :class="[
                'absolute left-0 top-0 z-10 text-sm transition-all duration-200 ease-in-out transform origin-left',
                'text-black/60 dark:text-white/70',
                labelClass,
                effect
                    ? 'translate-x-[14px] -translate-y-[9px] scale-[0.75]'
                    : 'translate-x-[14px] translate-y-[10px] scale-[1]',
            ]"
        >
            {{ placeholder }}
        </label>

        <div
            :class="[
                'relative flex items-center w-full rounded',
                inputWrapperClass,
            ]"
        >
            <component
                :is="mode === 'textarea' ? 'textarea' : 'input'"
                ref="inputRef"
                :type="mode === 'input' ? type : undefined"
                :name="input_name"
                :value="modelValue"
                :rows="mode === 'textarea' ? 1 : undefined"
                @focus="isFocus = true"
                @blur="isFocus = false"
                @input="handleInput"
                :class="[
                    'w-full px-[14px] py-[8.25px] bg-transparent outline-none',
                    'text-black dark:text-white',
                    mode === 'input'
                        ? 'h-[40px]'
                        : 'min-h-[40px] resize-none overflow-hidden',
                    inputClass,
                ]"
            />

            <fieldset
                class="absolute inset-x-0 -top-[5px] px-2 pointer-events-none border border-none rounded"
            >
                <legend
                    :class="[
                        'text-xs invisible max-w-[0.01px] overflow-hidden whitespace-nowrap transition-all duration-75',
                        effect ? 'max-w-full' : '',
                    ]"
                >
                    <span
                        class="px-[5px] opacity-0 visible bg-white/10 dark:bg-black/10"
                        >{{ placeholder }}</span
                    >
                </legend>
            </fieldset>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, nextTick } from 'vue';

const props = defineProps({
    modelValue: {
        type: String,
        default: '',
    },
    input_name: {
        type: String,
        default: '',
    },
    type: {
        type: String,
        default: 'text',
    },
    placeholder: {
        type: String,
        default: 'Enter something',
    },
    wrapperClass: {
        type: String,
        default: '',
    },
    inputClass: {
        type: String,
        default: '',
    },
    labelClass: {
        type: String,
        default: '',
    },
    inputWrapperClass: {
        type: String,
        default: '',
    },
    mode: {
        type: String as () => 'input' | 'textarea',
        default: 'input',
    },
});

const emit = defineEmits<{
    (e: 'update:modelValue', value: string): void;
}>();

const isFocus = ref(false);
const effect = ref(!!props.modelValue);
const inputRef = ref<HTMLInputElement | HTMLTextAreaElement | null>(null);

watch(isFocus, applyEffect);
watch(
    () => props.modelValue,
    () => {
        applyEffect();
        nextTick(() => {
            if (props.mode === 'textarea') adjustHeight();
        });
    },
);

function applyEffect() {
    effect.value = isFocus.value || !!props.modelValue;
}

function handleInput(event: Event) {
    const value = (event.target as HTMLInputElement | HTMLTextAreaElement)
        .value;
    emit('update:modelValue', value);
    if (props.mode === 'textarea') adjustHeight();
}

function adjustHeight() {
    const el = inputRef.value as HTMLTextAreaElement;
    if (!el || props.mode !== 'textarea') return;
    el.style.height = 'auto';
    el.style.height = `${el.scrollHeight}px`;
}

onMounted(() => {
    if (props.mode === 'textarea') nextTick(adjustHeight);
});
</script>
