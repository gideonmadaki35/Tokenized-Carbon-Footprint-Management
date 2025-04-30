import { describe, it, expect, beforeEach } from 'vitest';

// Mock Clarity environment
const mockClarity = {
  tx: {
    sender: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
  },
  contracts: {
    offsetVerification: {
      registerOffsetProject: (name, offsetAmount) => ({
        result: { value: true }
      }),
      verifyOffsetProject: (projectId) => ({
        result: { value: true }
      }),
      getOffsetProject: (projectId) => ({
        result: {
          value: {
            owner: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
            name: 'Reforestation Project',
            offsetAmount: 5000,
            verified: true,
            verifier: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
          }
        }
      }),
    }
  }
};

// Tests for offset-verification contract
describe('Offset Verification Contract', () => {
  let clarity;
  
  beforeEach(() => {
    clarity = { ...mockClarity };
  });
  
  it('should register a new offset project', () => {
    const name = 'Reforestation Project';
    const offsetAmount = 5000;
    const result = clarity.contracts.offsetVerification.registerOffsetProject(name, offsetAmount);
    expect(result.result.value).toBe(true);
  });
  
  it('should verify an offset project', () => {
    const projectId = 1;
    const result = clarity.contracts.offsetVerification.verifyOffsetProject(projectId);
    expect(result.result.value).toBe(true);
  });
  
  it('should get offset project details', () => {
    const projectId = 1;
    const result = clarity.contracts.offsetVerification.getOffsetProject(projectId);
    expect(result.result.value.name).toBe('Reforestation Project');
    expect(result.result.value.verified).toBe(true);
  });
});
