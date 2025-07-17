<template>
  <div class="upload-box">
    <!-- 图片选择 + 预览 -->
    <div class="image-selector" @click="triggerSelect" v-if="!previewUrl">
      <span class="plus">+</span>
    </div>
    <div v-else class="preview-container">
      <img :src="previewUrl" class="preview-image" />
      <div class="close-btn" @click="clearPreview">✖</div>
    </div>

    <!-- 上传按钮 -->
    <el-button
      type="primary"
      :disabled="!selectedFile"
      @click="uploadImage"
    >
      上传
    </el-button>

    <!-- 隐藏文件选择框 -->
    <input
      ref="fileInput"
      type="file"
      accept="image/*"
      @change="handleFileChange"
      style="display: none"
    />
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getBaseUrl } from '@/utils/format'
import { useUserStore } from '@/pinia'
import { isImageMime } from '@/utils/image'

// 组件名定义
defineOptions({
  name: 'UploadCommon'
})

// 支持 v-model 绑定
const modelValue = defineModel('modelValue')

const props = defineProps({
  classId: {
    type: Number,
    default: 0
  }
})

const emit = defineEmits(['upload-success'])

const userStore = useUserStore()
const token = userStore.token

const previewUrl = ref('')
const selectedFile = ref(null)
const fileInput = ref(null)

watch(modelValue, (val) => {
  if (val) previewUrl.value = getFullImageUrl(val)
})

const getFullImageUrl = (url) => {
  if (/^https?:\/\//.test(url)) return url
  return `${getBaseUrl()}/` + url
}

const triggerSelect = () => {
  fileInput.value?.click()
}

const handleFileChange = (e) => {
  const file = e.target.files[0]
  if (!file) return

  const isImage = isImageMime(file.type)
  const isLt500K = file.size / 1024 < 500

  if (!isImage) {
    ElMessage.error('只能上传图片文件')
    return
  }
  if (!isLt500K) {
    ElMessage.error('图片大小不能超过 500KB')
    return
  }

  selectedFile.value = file
  previewUrl.value = URL.createObjectURL(file)
  e.target.value = ''
}

const uploadImage = async () => {
  if (!selectedFile.value) {
    ElMessage.warning('请先选择图片')
    return
  }

  const formData = new FormData()
  formData.append('file', selectedFile.value)
  Object.entries(props.classId ? { classId: props.classId } : {}).forEach(([key, val]) => {
    formData.append(key, val)
  })

  try {
    const res = await fetch(`${getBaseUrl()}/fileUploadAndDownload/upload`, {
      method: 'POST',
      headers: { 'x-token': token },
      body: formData
    })
    const result = await res.json()
    if (result.code === 0 && result.data?.file?.url) {
      ElMessage.success('上传成功')
      modelValue.value = result.data.file.url
      emit('upload-success', result.data.file.url)
    } else {
      ElMessage.error(result.msg || '上传失败')
    }
  } catch (err) {
    ElMessage.error('网络错误，上传失败')
  }
}

const clearPreview = () => {
  selectedFile.value = null
  previewUrl.value = ''
  fileInput.value.value = ''
  modelValue.value = ''
}
</script>

<style scoped>
.upload-box {
  display: flex;
  align-items: center;
  gap: 20px;
}
.image-selector {
  width: 180px;
  height: 200px;
  border: 2px dashed #ccc;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  font-size: 60px;
  color: #999;
  border-radius: 8px;
}
.preview-container {
  width: 200px;
  height: 200px;
  position: relative;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  background: #f8f8f8;
}
.preview-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}
.close-btn {
  position: absolute;
  top: 4px;
  right: 6px;
  font-size: 16px;
  cursor: pointer;
  color: #666;
  background: white;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  text-align: center;
  line-height: 20px;
}
.close-btn:hover {
  color: red;
}
</style>
