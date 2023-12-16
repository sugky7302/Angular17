// To use this new makeStore function we need to create a new "client" component that will create the store and share it using the React-Redux Provider component.
'use client';
import { useRef } from 'react';
import { Provider } from 'react-redux';
import { makeStore, AppStore } from '../lib/store';
// If you need to initialize the store with data from the parent component,
// then define that data as a prop on the client StoreProvider component
// and use a Redux action on the slice to set the data in the store as shown below.
// Reference: https://redux.js.org/usage/nextjs#additional-configuration
//* import { initializeCount } from '../lib/features/counter/counterSlice'

export default function StoreProvider({ children }: { children: React.ReactNode }) {
    const storeRef = useRef<AppStore>();
    if (!storeRef.current) {
        // Create the store instance the first time this renders
        storeRef.current = makeStore();
        // storeRef.current.dispatch(initializeCount(count))
    }

    return <Provider store={storeRef.current}>{children}</Provider>;
}
