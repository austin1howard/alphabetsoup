import { describe, expect, it } from 'vitest'
import router from '../router'

describe('router', () => {
  it('starts with no routes', () => {
    expect(router.getRoutes()).toEqual([])
  })
})
