import { describe, it, expect, beforeEach } from 'vitest';

// Mock Clarity environment
const mockClarity = {
  tx: {
    sender: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
  },
  contracts: {
    emissionsTracking: {
      recordEmission: (amount, activityType) => ({
        result: { value: true }
      }),
      getEmission: (entity, activityId) => ({
        result: {
          value: {
            amount: 100,
            timestamp: 123456,
            activityType: 'transportation'
          }
        }
      }),
      getTotalEmissions: (entity) => ({
        result: { value: 500 }
      }),
    }
  }
};

// Tests for emissions-tracking contract
describe('Emissions Tracking Contract', () => {
  let clarity;
  
  beforeEach(() => {
    clarity = { ...mockClarity };
  });
  
  it('should record an emission', () => {
    const amount = 100;
    const activityType = 'transportation';
    const result = clarity.contracts.emissionsTracking.recordEmission(amount, activityType);
    expect(result.result.value).toBe(true);
  });
  
  it('should get emission details', () => {
    const entity = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
    const activityId = 1;
    const result = clarity.contracts.emissionsTracking.getEmission(entity, activityId);
    expect(result.result.value.amount).toBe(100);
    expect(result.result.value.activityType).toBe('transportation');
  });
  
  it('should get total emissions for an entity', () => {
    const entity = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
    const result = clarity.contracts.emissionsTracking.getTotalEmissions(entity);
    expect(result.result.value).toBe(500);
  });
});
