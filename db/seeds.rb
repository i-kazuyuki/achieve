n = 1
while n <= 100
  Blog.create(
    title: "あああ",
    user_id: n
  )
  n = n + 1
end