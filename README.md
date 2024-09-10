
## llama.cppをビルド
```
mingw32-make # MSYS2
make
```

## モデルをgguf形式に変換
```
python llama.cpp/convert_hf_to_gguf.py --outfile quantized_model/llama-3-youko-8b.gguf --outtype f16 model/llama-3-youko-8b
```

## .ggufファイルを4bit量子化
```
./llama.cpp/llama-quantize.exe "./quantized_model/llama-3-youko-8b.gguf" "./quantized_model/llama-3-youko-8b-q4_0.gguf" q4_0

./llama.cpp/llama-quantize.exe "./quantized_model/llama-3-youko-8b.gguf" "./quantized_model/llama-3-youko-8b-q8_0.gguf" q8_0
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

## 会話
```
./llama.cpp/llama-cli.exe -m ./quantized_model/llama-3-youko-8b-q4_0.gguf --color -i -n 128 -c 1024 -p "you are a helpful assistant" -cnv

./llama.cpp/llama-cli.exe -m ./quantized_model/llama-3-youko-8b-q8_0.gguf --color -i -n 128 -c 1024 -p "you are a helpful assistant" -cnv

./llama.cpp/llama-cli.exe -m ./quantized_model/llama-3-youko-8b.gguf --color -i -n 128 -c 1024 -i -p "you are a helpful assistant" --stop "<|im_end|>" -cnv

./llama.cpp/llama-cli.exe -m ./model/Llama-3-ELYZA-JP-8B-GGUF/Llama-3-ELYZA-JP-8B-q4_k_m.gguf --color -i -n 1024 -i --seed 42 -p "you are a helpful assistant" -cnv

./llama.cpp_build/llama.cpp_b3707/llama-cli -m ./model/Llama-3-ELYZA-JP-8B-GGUF/Llama-3-ELYZA-JP-8B-q4_k_m.gguf --color -i -n 1024 -i --seed 42 -p "you are a helpful assistant" -cnv
```

### 質問文
```
量子力学について日本語20文字以内で教えて下さい。
```

### オプション
```
-m <int>: モデルファイルのパス
--color: 出力カラーを使用
-i: 対話モードを有効化
-n <int>: max_tokens. -1:無制限 (EOSトークンに達するまで生成を続ける)
-c <int>: コンテキストサイズ（トークン数）を指定。このサイズを超えると、古い情報から「忘れ始める」。例: "-c 2048" とすると、モデルは最新の2048トークンのみを考慮します。
--ignore-eos: EOSトークンを無視する。EOSトークンが出現した後も出力が継続する可能性がある。
-ngl <int>: GPUレイヤー数 (GPUがある場合)
```

## seedを固定した場合でも回答が異なる場合の原因として考えられる可能性

理論上、完全に同じモデル、同じllama.cpp、同じシード値を使用すれば、異なるPCでも同じ回答が得られるはずです。しかし、実際にはいくつかの要因が影響する可能性があります：
* a) 完全な再現性が期待できる場合：

同じバージョンのllama.cppを使用
同じモデルファイル（バイト単位で同一）を使用
同じコンパイラ、同じコンパイルオプションでビルドされたllama.cpp
同じCPUアーキテクチャ（例：x86-64）
同じ浮動小数点演算の実装

* b) 回答に変動が現れる可能性がある場合：

異なるCPUアーキテクチャ（例：x86-64 vs ARM）
異なる浮動小数点演算の実装（例：Intel vs AMD）
異なるOSや環境変数の設定
異なるバージョンのllama.cppや、異なるコンパイルオプション
ハードウェアの違い（例：AVX命令セットの有無）

特に浮動小数点演算は、ハードウェアやコンパイラの違いによってわずかな違いが生じる可能性があり、これが累積して結果に影響を与えることがあります。
完全な再現性を確保するためには、同じハードウェア、OSバージョン、コンパイラ設定を使用することが理想的です。

同じOS、同じアーキテクチャの環境でコンパイル済みのllama.cppを使用する限り、コンパイラの設定の違いは結果の変動の原因として無視できると考えられます。しかし、ハードウェアやOSレベルの違いは依然として結果に影響を与える可能性があるため、完全な再現性を保証するためには、これらの要因も考慮する必要があります。



1. 浮動小数点演算の違い: CPUアーキテクチャや命令セットの違いにより、浮動小数点演算の実装が微妙に異なる場合があります。特に、異なる最適化オプションが適用された場合や、異なる数学ライブラリが使用された場合に、計算結果にわずかな差異が生じることがあります。これらの差異は、モデルの推論プロセスを通じて蓄積され、最終的な出力に影響を与える可能性があります。

2. 並列処理の違い: llama.cppは、マルチスレッド処理を利用してモデルの推論を高速化しています。CPUのアーキテクチャやコア数、キャッシュサイズの違いにより、スレッドの実行順序やメモリへのアクセス順序が変化することがあります。これらの違いは、浮動小数点演算の順序に影響を与え、結果的に計算結果に差異を生じさせる可能性があります。

ただし、これらの差異は通常非常に小さく、ほとんどの場合、回答の意味や内容に大きな影響を与えることはありません。それでも、再現性を厳密に要求されるアプリケーションでは、CPUの違いによる結果の差異を考慮する必要があるかもしれません。
再現性を高めるためには、以下の対策を検討することができます。

- 同じCPUアーキテクチャと命令セットを持つCPUを使用する: 例えば、Intel製CPUのみを使用するなど、CPUの種類を統一します。

- コンパイラオプションと数学ライブラリを統一する: ビルド時に使用するコンパイラやオプション、数学ライブラリを固定します。

- 並列処理を制限する: スレッド数を1に固定するなど、並列処理を無効化または制限します。ただし、これにより処理速度が低下する可能性があります。

## 環境確認コマンド
```
uname -a
python -V
pip list
gcc -v
clang -v
sha256sum ./model/Llama-3-ELYZA-JP-8B-GGUF/Llama-3-ELYZA-JP-8B-q4_k_m.gguf
sha256sum ./llama.cpp_build/llama.cpp_b3707/llama-cli.exe

cat /proc/cpuinfo

sysctl -a | grep machdep.cpu
system_profiler SPHardwareDataType
```