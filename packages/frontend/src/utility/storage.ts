/*
 * SPDX-FileCopyrightText: syuilo and misskey-project
 * SPDX-License-Identifier: AGPL-3.0-only
 */

<<<<<<< HEAD
import { computed, ref, shallowRef, watch, defineAsyncComponent } from 'vue';
=======
import { readonly, ref } from 'vue';
>>>>>>> misskey-dev-develop
import * as os from '@/os.js';
import { store } from '@/store.js';
import { i18n } from '@/i18n.js';

<<<<<<< HEAD
export const storagePersisted = ref(await navigator.storage.persisted());

export async function enableStoragePersistence() {
=======
export const storagePersistenceSupported = window.isSecureContext && 'storage' in navigator;
const storagePersisted = ref(false);

export async function getStoragePersistenceStatusRef() {
	if (storagePersistenceSupported) {
		storagePersisted.value = await navigator.storage.persisted().catch(() => false);
	}

	return readonly(storagePersisted);
}

export async function enableStoragePersistence() {
	if (!storagePersistenceSupported) return;
>>>>>>> misskey-dev-develop
	try {
		const persisted = await navigator.storage.persist();
		if (persisted) {
			storagePersisted.value = true;
		} else {
			os.alert({
				type: 'error',
				text: i18n.ts.somethingHappened,
			});
		}
	}	catch (err) {
		os.alert({
			type: 'error',
			text: i18n.ts.somethingHappened,
		});
	}
}

export function skipStoragePersistence() {
	store.set('showStoragePersistenceSuggestion', false);
}
