
<template>
  <div>
    <warning-bar title="提示：为了你的信息通过审核，请仔细填写下表" />

    <div class="gva-adduser-box">
      <el-form
        ref="userForm"
        :rules="rules"
        :model="userInfo"
        label-width="80px"
      >
        <el-form-item label="姓名" prop="userName">
          <el-input v-model="userInfo.userName" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userInfo.gender">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="出生年月" prop="birthDate">
          <el-date-picker
            v-model="userInfo.birthDate"
            type="month"
            placeholder="选择出生年月"
            style="width: 200px"
            value-format="yyyy-MM"
          />
        </el-form-item>

        <el-form-item label="民族" prop="mz">
          <el-select v-model="userInfo.mz" placeholder="请选择民族" style="width: 200px">
            <el-option
              v-for="item in nations"
              :key="item"
              :label="item"
              :value="item"
            />
          </el-select>
        </el-form-item>

        <el-form-item>
          <el-row justify="center">
            <el-col>
              <el-button @click="enterAddjobDialog" type="primary" round>证书录入</el-button>
              <el-button @click="closeAddjobDialog" type="primary" round>重新填写</el-button>
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
    </div>

    <el-drawer
      v-model="addUserDialog"
      :size="appStore.drawerSize"
      :show-close="false"
      :close-on-press-escape="false"
      :close-on-click-modal="false"
    >
      <el-form
        ref="userForm"
        :rules="rules"
        :model="userInfo"
        label-width="80px"
      >
        <el-form-item label="头像">
          <SelectImage v-model="userInfo.headerImg" />
        </el-form-item>
      </el-form>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAppStore } from '@/pinia'
import SelectImage from '@/components/selectImage/selectImage.vue'
import WarningBar from '@/components/warningBar/warningBar.vue'

defineOptions({
  name: 'certificateAdd'
})

const appStore = useAppStore()

const addUserDialog = ref(false)

const userInfo = ref({
  userName: '',
  gender: '男',
  birthDate: '',
  mz: '汉族',
  headerImg: '',
})

const nations = [
  "汉族", "蒙古族", "回族", "藏族", "维吾尔族", "苗族", "彝族", "壮族", "布依族", "朝鲜族",
  "满族", "侗族", "瑶族", "白族", "土家族", "哈尼族", "哈萨克族", "傣族", "黎族", "傈僳族",
  "佤族", "畲族", "高山族", "拉祜族", "水族", "东乡族", "纳西族", "景颇族", "柯尔克孜族", "土族",
  "达斡尔族", "仫佬族", "羌族", "布朗族", "撒拉族", "毛南族", "仡佬族", "锡伯族", "阿昌族", "普米族",
  "塔吉克族", "怒族", "乌孜别克族", "俄罗斯族", "鄂温克族", "德昂族", "保安族", "裕固族", "京族", "塔塔尔族",
  "独龙族", "鄂伦春族", "赫哲族", "门巴族", "珞巴族", "基诺族"
]

const rules = ref({
  userName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  birthDate: [{ required: true, message: '请选择出生年月', trigger: 'change' }],
  mz: [{ required: true, message: '请选择民族', trigger: 'change' }],
})

const enterAddjobDialog = () => {
  addUserDialog.value = true
}

const closeAddjobDialog = () => {
  userInfo.value = {
    userName: '',
    gender: '男',
    birthDate: '',
    mz: '汉族',
    headerImg: '',
  }
  addUserDialog.value = false
}
</script>

<style lang="scss" scoped>
.header-img-box {
  @apply w-52 h-52 border border-solid border-gray-300 rounded-xl flex justify-center items-center cursor-pointer;
}
</style>
