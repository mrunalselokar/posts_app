import { useState } from "react"

export const ToDo = () => {
  const [todos, setTodos] = useState([])
  const [isEditing, setIsEditing] = useState(false)
  const [currentTodo, setCurrentTodo] = useState(null)
  const [currentTitle, setCurrentTitle] = useState("")
  const [currentDescription, setCurrentDescription] = useState("")

  const clearForm = () => {
    setCurrentTitle("")
    setCurrentDescription("")
    setCurrentTodo(null)
    setIsEditing(false)
  }

  const nextTaskId = (todosList) => {
    if (!todosList.length) {
      return 1
    }

    return Math.max(...todosList.map((task) => task.id)) + 1
  }

  const addTask = () => {
    const title = currentTitle.trim()
    if (!title) return

    setTodos((prev) => [
      ...prev,
      {
        id: nextTaskId(prev),
        title,
        description: currentDescription.trim(),
        completed: false,
      },
    ])

    clearForm()
  }

  const removeTask = (todoToRemove) => {
    setTodos((prev) => prev.filter((todo) => todo.id !== todoToRemove.id))

    if (currentTodo?.id === todoToRemove.id) {
      clearForm()
    }
  }

  const toggleTask = (todoToToggle) => {
    setTodos((prev) =>
      prev.map((todo) =>
        todo.id === todoToToggle.id ? { ...todo, completed: !todo.completed } : todo
      )
    )

    if (currentTodo?.id === todoToToggle.id) {
      setCurrentTodo((prev) => ({ ...prev, completed: !prev.completed }))
    }
  }

  const startEditing = (todo) => {
    setIsEditing(true)
    setCurrentTodo(todo)
    setCurrentTitle(todo.title)
    setCurrentDescription(todo.description)
  }

  const updateTask = () => {
    if (!currentTodo) return

    setTodos((prev) =>
      prev.map((todo) =>
        todo.id === currentTodo.id
          ? { ...todo, title: currentTitle.trim(), description: currentDescription.trim() }
          : todo
      )
    )

    clearForm()
  }

  return (
    <div>
      <h2>Tasks</h2>

      <ul>
        {todos.map((todo) => (
          <li key={todo.id}>
            <label>
              <input
                type="checkbox"
                checked={todo.completed}
                onChange={() => toggleTask(todo)}
              />
              {`${todo.id}: ${todo.title} - ${todo.description}`}
            </label>

            <button onClick={() => startEditing(todo)}>Edit</button>
            <button onClick={() => removeTask(todo)}>Delete</button>
          </li>
        ))}
      </ul>

      <div style={{ marginTop: "1rem" }}>
        <input
          type="text"
          placeholder="Title"
          value={currentTitle}
          onChange={(e) => setCurrentTitle(e.target.value)}
        />
        <input
          type="text"
          placeholder="Description"
          value={currentDescription}
          onChange={(e) => setCurrentDescription(e.target.value)}
        />

        {isEditing ? (
          <>
            <button onClick={updateTask}>Save</button>
            <button onClick={clearForm}>Cancel</button>
          </>
        ) : (
          <button onClick={addTask}>Add a new Task</button>
        )}
      </div>
    </div>
  )
}
