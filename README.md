
## llama.cppをビルド
```
mingw32-make
```

## モデルをgguf形式に変換
```
python llama.cpp/convert_hf_to_gguf.py --outfile quantized_model/llama-3-youko-8b.gguf --outtype f16 model/llama-3-youko-8b
```

## .ggufファイルを4bit量子化
```
./llama.cpp/llama-quantize.exe "./quantized_model/llama-3-youko-8b.gguf" "./quantized_model/llama-3-youko-8b-q4_0.gguf" q4_0
```

### 参考
```
./llama-quantize.exe --help
usage: C:\msys64\home\YUU\dev\llama.cpp\llama-quantize.exe [--help] [--allow-requantize] [--leave-output-tensor] [--pure] [--imatrix] [--include-weights] [--exclude-weights] [--output-tensor-type] [--token-embedding-type] [--override-kv] model-f32.gguf [model-quant.gguf] type [nthreads]

  --allow-requantize: Allows requantizing tensors that have already been quantized. Warning: This can severely reduce quality compared to quantizing from 16bit or 32bit
  --leave-output-tensor: Will leave output.weight un(re)quantized. Increases model size but may also increase quality, especially when requantizing
  --pure: Disable k-quant mixtures and quantize all tensors to the same type
  --imatrix file_name: use data in file_name as importance matrix for quant optimizations
  --include-weights tensor_name: use importance matrix for this/these tensor(s)
  --exclude-weights tensor_name: use importance matrix for this/these tensor(s)
  --output-tensor-type ggml_type: use this ggml_type for the output.weight tensor
  --token-embedding-type ggml_type: use this ggml_type for the token embeddings tensor
  --keep-split: will generate quantized model in the same shards as input
  --override-kv KEY=TYPE:VALUE
      Advanced option to override model metadata by key in the quantized model. May be specified multiple times.
Note: --include-weights and --exclude-weights cannot be used together
```
