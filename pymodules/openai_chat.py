""" openai_chat.py
desc:       module for creating and returning an OpenAI chat completion
requires:   openai
usage:      import module openai_chat
            openai_chat.response("Reply as an expert Python developer", "How do I...")
            openai_chat.response("Reply as an expert Python developer", "How do I...", tokens=500, model=gpt-3.5-turbo, temp=1.3)
            response = openai_chat.response("Reply as an expert Python developer", user_query)
            print(response["output"])
note:       openai module expects but does not require OPENAI_API_KEY environment variable
"""

# import modules
import os

# import non-standard/custom modules
import openai

# set variables
model = os.environ.get("OPENAI_MODEL")
tokens = 150
temperature = 0


# function to generate response
def response(
    system_prompt, user_prompt, tokens=tokens, model=model, temperature=temperature
):
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt},
    ]

    response = openai.ChatCompletion.create(
        temperature=temperature,
        max_tokens=tokens,
        model=model,
        messages=messages,
    )

    output = response.choices[0].message.content
    return {"output": output}