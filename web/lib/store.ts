// store as a global or module-singleton variable, to defining a makeStore function that returns a new store for each request.
// makeStore, that we can use to create a store instance per-request while retaining the strong type safety
// (if you choose to use TypeScript) that Redux Toolkit provides.
import { configureStore } from '@reduxjs/toolkit'

export const makeStore = () => {
  return configureStore({
    reducer: {}
  })
}

// Infer the type of makeStore
export type AppStore = ReturnType<typeof makeStore>
// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<AppStore['getState']>
export type AppDispatch = AppStore['dispatch']