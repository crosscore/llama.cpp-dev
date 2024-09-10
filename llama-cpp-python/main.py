from llama_cpp import Llama

model_path = "../model/Llama-3-ELYZA-JP-8B-GGUF/Llama-3-ELYZA-JP-8B-q4_k_m.gguf"

llm = Llama(
    model_path=model_path,
    n_ctx=1024,
    seed=42,
)

system_prompt = "you are a helpful assistant"
user_question = "量子力学について日本語20文字以内で教えて下さい。"

output = llm.create_chat_completion(
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_question}
    ],
    temperature=0.7,
    max_tokens=1024,
    stream=True,
)

for chunk in output:
    if chunk['choices'][0]['delta'].get('content'):
        content = chunk['choices'][0]['delta']['content']
        print(content, end='', flush=True)
print()
