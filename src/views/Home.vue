<template lang="pug">
  v-layout(row, wrap)
    v-flex(text-xs-center)
      h1.primary--text.display-3.font-weight-medium.my-3 TODOS
      v-card
        v-list.pa-0
          v-list-tile
            v-list-tile-action
              v-checkbox(
                :input-value="allChecked",
                @change="toggleAll(!allChecked)",
                color="primary"
                v-if="todos.length > 0")
              v-icon(
                color="primary",
                v-else) check
            v-text-field(
              :label="'New todo input'",
              @keydown.enter="addTodo",
              autofocus,
              browser-autocomplete="off",
              clearable,
              color="primary",
              flat,
              hide-details,
              maxlength="1023",
              placeholder="What needs to be done?",
              solo,
              v-model="newTodo")

      v-card(class="mt-3", v-show="todos.length")
        v-progress-linear.my-0(v-model="progressPercentage")/
        v-card-actions.px-3(v-show="todos.length")
          span.primary--text {{ remaining }} {{ remaining | pluralize('item') }} left
          v-spacer
          v-btn-toggle(
            class="elevation-0",
            mandatory,
            v-model="visibility",
            v-show="todos.length")
            v-btn(
              :key="key",
              :to="key",
              :value="key",
              class="mx-0",
              color="primary",
              flat,
              small,
              v-for="(val, key) in filters") {{ key | capitalize }}

        v-list.pa-0
          template(v-for="todo in filteredTodos")
            v-divider(:key="`${todo.uid}-divider`")
            TodoItem(
              :key="todo.uid",
              :todo="todo")/
      v-btn(
        @click="clearCompleted",
        block,
        class="mt-3",
        color="primary",
        depressed,
        round,
        v-show="todos.length > remaining") Clear completed

      footer-info
    </v-flex>
  </v-layout>
</template>

<script>
import { mapActions } from 'vuex'
import TodoItem from '@/components/TodoItem.vue'
import FooterInfo from '@/components/FooterInfo.vue'

const filters = {
  all: todos => todos,
  active: todos => todos.filter(todo => !todo.done),
  completed: todos => todos.filter(todo => todo.done)
}

export default {
  props: ['filter'],
  components: {
    TodoItem,
    FooterInfo
  },
  data () {
    return {
      newTodo: '',
      filters: filters,
      visibility: this.filter
    }
  },
  computed: {
    todos () {
      return this.$store.state.todos
    },
    allChecked () {
      return this.todos.every(todo => todo.done)
    },
    filteredTodos () {
      return filters[this.visibility](this.todos)
    },
    remaining () {
      return this.todos.filter(todo => !todo.done).length
    },
    progressPercentage () {
      const len = this.todos.length
      return ((len - this.remaining) * 100) / len
    }
  },
  methods: {
    ...mapActions([
      'toggleAll',
      'clearCompleted'
    ]),
    addTodo () {
      const text = this.newTodo.trim()
      if (text) {
        this.$store.dispatch('addTodo', text)
      }
      this.newTodo = ''
    }
  },
  filters: {
    pluralize: (n, w) => n === 1 ? w : (w + 's'),
    capitalize: s => s.charAt(0).toUpperCase() + s.slice(1)
  }
}
</script>

<style lang="stylus">
h1
  opacity: 0.3
.v-text-field .v-input__slot
  padding: 0 !important
</style>
