<template>
  <div>
    <warning-bar
  :title="`温馨提示：为了你的信息通过审核，请仔细填写下表。\n1、上传照片要求：照片必须是近期正面免冠彩色头像，不小于295像素(宽)x413像素(高)，头部占尺寸的2/3，白色背景无边框，图像清晰、层次丰富、神态自然、无明显畸变。\n2、系统将对所填姓名、证件类型、证件号码、个人照片进行实名认证，请填写个人真实信息，上传个人真实照片。\n3、上传的照片用于考生报名及合格人员证书制作。`"
  style="color: red; white-space: pre-line"
/>
    <div class="gva-adduser-box">
      <el-form ref="userForm" :rules="rules" :model="userInfo" label-width="80px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="userInfo.name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="sex">
          <el-radio-group v-model="userInfo.sex">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="出生年月" prop="age">
          <el-date-picker
            v-model="userInfo.age"
            type="month"
            placeholder="选择出生年月"
            style="width: 200px"
            value-format="YYYY-MM"
          />
        </el-form-item>

        <el-form-item label="民族" prop="mingzhu">
          <el-select v-model="userInfo.mingzhu" placeholder="请选择民族" style="width: 200px">
            <el-option v-for="item in nations" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>

        <el-form-item label="证件照片" prop="pic" label-width="80px">
          <SelectImage v-model="userInfo.pic" />
        </el-form-item>

        <el-form-item label="籍贯" prop="nativeplace">
          <el-select v-model="userInfo.nativeplace" placeholder="请选择籍贯" style="width: 200px" filterable>
            <el-option v-for="place in nativeplaces" :key="place" :label="place" :value="place" />
          </el-select>
        </el-form-item>

        <el-form-item label="政治面貌" prop="zzmm">
          <el-input v-model="userInfo.zzmm" style="width: 200px" />
        </el-form-item>

        <el-form-item label="成次" prop="chengchi">
          <el-input v-model="userInfo.chengchi" style="width: 200px" />
        </el-form-item>

        <el-form-item label="身份证号" prop="certificatenumber2">
          <el-input
            v-model="userInfo.certificatenumber2"
            style="width: 200px"
            placeholder="请输入18位身份证号码"
          />
        </el-form-item>

        <el-form-item label="专业" prop="zhuanye">
          <el-input v-model="userInfo.zhuanye" style="width: 200px" />
        </el-form-item>

        <el-form-item label="毕业院校" prop="graduschool2">
          <el-input
            v-model="userInfo.graduschool2"
            style="width: 200px"
            disabled
          />
        </el-form-item>

        <el-form-item label="毕业时间" prop="bysj">
          <el-date-picker
            v-model="userInfo.bysj"
            type="month"
            placeholder="选择毕业年月"
            style="width: 200px"
            value-format="YYYY-MM"
          />
        </el-form-item>

        <el-form-item label="自我鉴定" prop="zwjd">
          <el-input v-model="userInfo.zwjd" style="width: 300px" />
        </el-form-item>

        <el-form-item label="备注" prop="demo">
          <el-input v-model="userInfo.demo" style="width: 300px" />
        </el-form-item>

        <el-form-item>
          <el-row justify="center">
            <el-col>
              <el-button @click="addUserFunc" type="primary" round>证书录入</el-button>
              <el-button @click="resetUserFunc" type="primary" round>重新填写</el-button>
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useAppStore } from '@/pinia'
//import SelectImage from '@/components/selectImage/selectImage.vue'
//import SelectImage from '@/components/upload/common.vue'
import SelectImage from '@/components/upload/zsCommon.vue'
import WarningBar from '@/components/warningBar/warningBar.vue'
import { insertZhengshu } from '@/api/user.js'
import { useUserStore } from '@/pinia/modules/user'

defineOptions({ name: 'certificateAdd' })

const appStore = useAppStore()
const userStore = useUserStore()

const userInfo = ref({
  name: '',
  sex: 1,
  age: '',
  mingzhu: '汉族',
  pic: '',
  nativeplace: '',
  zzmm: '',
  chengchi: '',
  certificatenumber2: '',
  zhuanye: '',
  graduschool2: '北京长城学院',
  bysj: '',
  zwjd: '',
  demo: '',
  editer:userStore.userInfo.userName
})

const nations = [
  "汉族", "蒙古族", "回族", "藏族", "维吾尔族", "苗族", "彝族", "壮族", "布依族", "朝鲜族",
  "满族", "侗族", "瑶族", "白族", "土家族", "哈尼族", "哈萨克族", "傣族", "黎族", "傈僳族",
  "佤族", "畲族", "高山族", "拉祜族", "水族", "东乡族", "纳西族", "景颇族", "柯尔克孜族", "土族",
  "达斡尔族", "仫佬族", "羌族", "布朗族", "撒拉族", "毛南族", "仡佬族", "锡伯族", "阿昌族", "普米族",
  "塔吉克族", "怒族", "乌孜别克族", "俄罗斯族", "鄂温克族", "德昂族", "保安族", "裕固族", "京族", "塔塔尔族",
  "独龙族", "鄂伦春族", "赫哲族", "门巴族", "珞巴族", "基诺族"
]
const nativeplaces = [
  "北京", "上海", "天津", "重庆", "河北", "山西", "辽宁", "吉林", "黑龙江", "江苏", "浙江", "安徽",
  "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "海南", "四川", "贵州", "云南", "陕西",
  "甘肃", "青海", "台湾", "内蒙古", "广西", "西藏", "宁夏", "新疆", "香港", "澳门"
]

const rules = ref({
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  sex: [{ required: true, message: '请选择性别', trigger: 'change' }],
  age: [{ required: true, message: '请选择出生年月', trigger: 'change' }],
  mingzhu: [{ required: true, message: '请选择民族', trigger: 'change' }],
  certificatenumber2: [
    { required: true, message: '请输入身份证号', trigger: 'blur' },
    {
      pattern: /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])\d{3}[\dXx]$/,
      message: '请输入合法的18位身份证号码',
      trigger: 'blur'
    }
  ],
  pic: [{ required: true, message: '请上传证件照', trigger: 'change' }],
  nativeplace: [{ required: true, message: '请选择籍贯', trigger: 'change' }],
  zhuanye: [{ required: true, message: '请输入专业', trigger: 'blur' }],
  bysj: [{ required: true, message: '请选择毕业时间', trigger: 'change' }]
})

const addUserFunc = async () => {
  //userInfo.value.age = formatDateToMonth(userInfo.value.age)
  //userInfo.value.bysj =formatDateToMonth(userInfo.value.bysj)
  
  try {
    const res = await insertZhengshu(userInfo.value)
    if (res.code === 0) {
      ElMessage.success('创建成功')
      resetUserFunc()
    }
  } catch (error) {
    ElMessage.error('提交失败，请重试')
  }
}

const resetUserFunc = () => {
  Object.assign(userInfo.value, {
    name: '',
    sex: 1,
    age: '',
    mingzhu: '汉族',
    pic: '',
    nativeplace: '',
    zzmm: '',
    chengchi: '',
    certificatenumber2: '',
    zhuanye: '',
    graduschool2: '北京长城学院',
    bysj: '',
    zwjd: '',
    demo: ''
  })
}

const formatDateToMonth = (date) => {
  if (!date) return ''
  const d = new Date(date)
  const year = d.getFullYear()
  const month = (d.getMonth() + 1).toString().padStart(2, '0')
  return `${year}-${month}`
}

</script>

<style lang="scss" scoped>
.header-img-box {
  @apply w-52 h-52 border border-solid border-gray-300 rounded-xl flex justify-center items-center cursor-pointer;
}

.warning-bar-text {
  color: red;
  white-space: pre-line;
}
</style>
