<!--
    @auther: bypanghu<bypanghu@163.com>
    @date: 2024/5/8
!-->

<template>
  <div class="grid grid-cols-2 gap-2">
    <a
      v-for="item in wikis"
      :key="item.url"
      :href="item.url"
      class="text-sm text-gray-700 dark:text-gray-300 no-underline hover:text-active"
      target="_blank"
    >
      {{ item.title }}
    </a>
  </div>
</template>

<script setup>
  const wikis = [
    {
      title: 'Vue3',
      url: 'https://v3.cn.vuejs.org/guide/introduction.html'
    },
    {
      title: 'GIN 文档',
      url: 'https://gin-gonic.com/'
    },
    {
      title: 'GVA 文档',
      url: 'https://www.baidu.com/'
    },
    {
      title: '插件市场',
      url: 'www.soso.com'
    },
    {
      title: 'github 仓库',
      url: 'www.google.com'
    }
  ]
</script>

<style scoped lang="scss"></style>
