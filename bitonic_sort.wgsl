// bitonic_sort.wgsl

@group(0) @binding(0)
var<storage, read_write> data: array<f32>;

@group(0) @binding(1)
var<uniform> params: Params;

struct Params {
  N: u32,
}

fn compareAndSwap(i: u32, j: u32, dir: bool) {
  if (i >= params.N || j >= params.N) {
    return;
  }
  let temp: f32 = data[i];
  if ((dir && data[i] > data[j]) || (!dir && data[i] < data[j])) {
    data[i] = data[j];
    data[j] = temp;
  }
}

@compute @workgroup_size(256)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
  let i = global_id.x;
  let N = params.N;

  var k: u32 = 2u;
  while (k <= N) {
    var j = k >> 1u;
    while (j > 0u) {
      let ixj = i ^ j;
      if (ixj > i) {
        let dir = ((i & k) == 0u);
        compareAndSwap(i, ixj, dir);
      }
      j = j >> 1u;
      workgroupBarrier();
    }
    k = k << 1u;
    workgroupBarrier();
  }
}
