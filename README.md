
## llama.cppをビルド
```
mingw32-make
```

## モデルをgguf形式に変換
```
python convert_hf_to_gguf.py --outfile /home/YUU/dev/quantized_model/llama-3-youko-8b.gguf -outtype f16 /home/YUU/dev/model/llama-3-youko-8b

python convert_hf_to_gguf.py --outfile llama-3-youko-8b.gguf --outtype f16 ../model/llama-3-youko-8b
```
