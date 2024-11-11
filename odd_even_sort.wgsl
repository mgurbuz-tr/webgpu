@group(0) @binding(0)
var<storage, read_write> data: array<f32>;

@compute @workgroup_size(256)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
  let N = arrayLength(&data);
  let i = global_id.x;

  for (var iter = 0u; iter < N; iter = iter + 1u) {
    let idx = i * 2u + (iter & 1u);
    if (idx + 1u < N) {
      if (data[idx] > data[idx + 1u]) {
        let temp = data[idx];
        data[idx] = data[idx + 1u];
        data[idx + 1u] = temp;
      }
    }
    workgroupBarrier();
  }
}
